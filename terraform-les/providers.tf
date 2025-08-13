terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.149.0"  # Используйте актуальную версию
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"     # Актуальная версия local провайдера
    }
  }
}

provider "yandex" {
  service_account_key_file  = var.yc_key_file
  cloud_id                  = var.yc_cloud_id
  folder_id                 = var.yc_folder_id
  zone                      = "ru-central1-a"
}