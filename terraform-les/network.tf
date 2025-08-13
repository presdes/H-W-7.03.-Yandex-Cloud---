# ---------------------- NETWORK ------------------------------
# VPC LAN
resource "yandex_vpc_network" "test_network" {
  name = "test-network"
}

# Subnet A
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.test_network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

# Subnet B
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.test_network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

# NAT for out link (internet access)
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.flow}"
  shared_egress_gateway {}
}

# Network route for internet access via NAT
resource "yandex_vpc_route_table" "rt" {
    name        = "fops-route-table-${var.flow}"
    network_id  = yandex_vpc_network.test_network.id

    static_route {
        destination_prefix  = "0.0.0.0/0"
        gateway_id          = yandex_vpc_gateway.nat_gateway.id
    }
  
}

# Firewal (Sec. Groups)
resource "yandex_vpc_security_group" "bastion" {
  name  = "bastion-sg-${var.flow}"
  network_id = yandex_vpc_network.test_network.id
  ingress {
    description     = "Allow 0.0.0.0/0"
    protocol        = "TCP"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 22
  }
  egress {
    description     = "Permit ANY"
    protocol        = "ANY"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    from_port       = 0
    to_port         = 65535
  }
}

resource "yandex_vpc_security_group" "LAN" {
    name = "LAN-sg-${var.flow}"
    network_id = yandex_vpc_network.test_network.id
    ingress {
        description     = "Allow 10.0.0.0/8"
        protocol        = "ANY"
        v4_cidr_blocks  = ["10.0.0.0/8"]
        from_port       = 0
        to_port         = 65535        
    }
    egress {
        description     = "Permit ANY"
        protocol        = "ANY"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        from_port       = 0
        to_port         = 65535
    }
  
}

resource "yandex_vpc_security_group" "web_sg" {
  name          = "web-sg-${var.flow}"
  network_id    = yandex_vpc_network.test_network.id

  ingress {
    description    = "Allow HTTPS"
    protocol        = "TCP"
    port            = 443
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol        = "TCP"
    port            = 80
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }

}