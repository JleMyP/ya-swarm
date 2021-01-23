resource "yandex_iam_service_account" "swarm_account" {
  name = "ig-sa"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.ya_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.swarm_account.id}",
  ]
}

resource "yandex_vpc_network" "swarm_network" {
  name = "network1"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.swarm_network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.2.0/24"]
  network_id     = yandex_vpc_network.swarm_network.id
  route_table_id = yandex_vpc_route_table.nat_route.id
}

resource "yandex_vpc_route_table" "nat_route" {
  name       = "nat"
  network_id = yandex_vpc_network.swarm_network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = module.master.internal_ip
  }
}

module "master" {
  source = "./modules/master"

  ya_folder_id = var.ya_folder_id

  subnet_id    = yandex_vpc_subnet.public.id
  image_family = var.master_image_family
  image_id     = var.master_image_id

  user_data = templatefile("user-data-master.yml", {
    ssh-pub-key = file("${path.root}/key.pub"),
  })
  ssh_private_key = file("${path.root}/key.private")
}

module "workers_group" {
  source = "./modules/group"

  ya_service_account_id = yandex_iam_service_account.swarm_account.id
  ya_folder_id          = var.ya_folder_id

  network_id   = yandex_vpc_network.swarm_network.id
  subnet_id    = yandex_vpc_subnet.private.id
  image_family = var.worker_image_family
  image_id     = var.worker_image_id

  user_data = templatefile("user-data-worker.yml", {
    swarm-token = module.master.swarm_token,
    master-host = "master",
    ssh-pub-key = file("${path.root}/key.pub"),
  })

  depends_on = [yandex_resourcemanager_folder_iam_binding.editor]
}

data "cloudflare_zones" "domain" {
  filter {
    name = var.domain_name
  }
}

# TODO: цикл по ресурсам
resource "cloudflare_record" "root" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  value   = module.master.external_ip
  type    = "A"
  proxied = true
}


resource "cloudflare_zone_settings_override" "domain" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  settings {
    ssl = "flexible"
  }
}
