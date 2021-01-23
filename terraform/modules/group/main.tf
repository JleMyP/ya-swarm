terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.47.0"
    }
  }
}

data "yandex_compute_image" "image" {
  folder_id = var.ya_folder_id
  family    = var.image_family
}


resource "yandex_compute_instance_group" "workers_group" {
  name               = "autoscaled-ig"
  folder_id          = var.ya_folder_id
  service_account_id = var.ya_service_account_id

  instance_template {
    platform_id = "standard-v2"

    name     = "worker-{instance.index}"
    hostname = "worker-{instance.index}"

    resources {
      memory = 2
      cores  = 2
    }

    scheduling_policy {
      preemptible = true
    }

    boot_disk {
      initialize_params {
        type     = "network-hdd"
        image_id = var.image_id != "" ? var.image_id : data.yandex_compute_image.image.id
      }
    }

    network_interface {
      network_id = var.network_id
      subnet_ids = [var.subnet_id]
    }

    metadata = {
      user-data = var.user_data
    }
  }

  scale_policy {
    auto_scale {
      initial_size           = 1
      measurement_duration   = 60
      cpu_utilization_target = 75
      min_zone_size          = 1
      max_size               = 3
      warmup_duration        = 60
      stabilization_duration = 60
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_creating    = 1
    max_deleting    = 1
    max_unavailable = 0
    max_expansion   = 2
  }
}
