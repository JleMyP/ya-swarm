terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.47.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "2.0.0"
    }
  }
}

data "yandex_compute_image" "image" {
  folder_id = var.ya_folder_id
  family    = var.image_family
}


resource "yandex_compute_instance" "master" {
  name        = "master"
  hostname    = "master"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 0.5
    core_fraction = 5
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      type     = "network-ssd"
      image_id = var.image_id != "" ? var.image_id : data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    user-data          = var.user_data
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init",
    ]

    connection {
      type        = "ssh"
      user        = "tim"
      host        = self.network_interface[0].nat_ip_address
      port        = 10025
      private_key = var.ssh_private_key
      timeout     = "2m"
    }
  }
}

# todo: rel path
data "external" "swarm_token" {
  program = ["bash", "${path.module}/export-token.sh", yandex_compute_instance.master.network_interface[0].nat_ip_address]
}
