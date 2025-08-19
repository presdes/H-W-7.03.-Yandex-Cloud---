# Read boot image id
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

# Bastion Server
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"       # Instance Name VM
  hostname    = "bastion"       # FDQN host name VM (Without hostname, a random name will be generated.)
  platform_id = "standard-v3"
  zone        = "ru-central1-a" # The VM zone must match the subnet zone!

# Leased VM resources ($)
  resources {
    cores         = 2   # Number of CPU cores
    memory        = 1   # Amount of memory in GB
    core_fraction = 20  # Guaranteed CPU share %
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd" # Type disk ($)
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml") # Must not exceed 64 KB
    serial-port-enable = 1 # Console logs
  }

  scheduling_policy { preemptible = true } # interruptible virtual machine ($)

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id # The VM zone must match the subnet zone!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.bastion.id]
  }
}

# WEB Server a
resource "yandex_compute_instance" "web_a" {
  name        = "web-a" # Instance Name VM
  hostname    = "web-a" # FDQN host name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"


  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}

# WEB Server b
resource "yandex_compute_instance" "web_b" {
  name        = "web-b"
  hostname    = "web-b"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores         = var.vm_res.cores
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  }
}

# Creating Ansible inventory file via Terraform
resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

  [webservers]
  ${yandex_compute_instance.web_a.network_interface.0.ip_address}
  ${yandex_compute_instance.web_b.network_interface.0.ip_address}
  [webservers:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
  XYZ
  filename = "./hosts.ini"
}
