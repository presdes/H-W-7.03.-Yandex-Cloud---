variable "yc_key_file" {
  type  = string
  default = ""
}

variable "yc_cloud_id" {
  type  = string
  default = ""
}

variable "yc_folder_id" {
  type  = string
  default = ""
}

variable "flow" {
  type  = string
  default = "11-08"
}

variable "vm_res" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}