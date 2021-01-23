terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.47.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.14.0"
    }

  }
}

provider "yandex" {
  token     = var.ya_token
  cloud_id  = var.ya_cloud_id
  folder_id = var.ya_folder_id
  zone      = "ru-central1-a"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
