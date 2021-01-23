variable "ya_token" {
  type        = string
  description = "yandex cloud OAuth token"
}

variable "ya_cloud_id" {
  type        = string
  description = "yandex cloud id"
}

variable "ya_folder_id" {
  type        = string
  description = "yandex cloud folder id"
}

variable "cloudflare_email" {
  type        = string
  description = "cloudflare account email"
}

variable "cloudflare_api_key" {
  type        = string
  description = "cloudflare api key"
}

variable "domain_name" {
  type        = string
  description = "root domain name"
}

variable "master_image_family" {
  type        = string
  description = "image family for master node"
  default     = "master"
}

variable "master_image_id" {
  type        = string
  description = "concrete image id for master node"
  default     = ""
}

variable "worker_image_family" {
  type        = string
  description = "image family for workers nodes"
  default     = "ubuntu-20-docker"
}

variable "worker_image_id" {
  type        = string
  description = "concrete image id for workers nodes"
  default     = ""
}
