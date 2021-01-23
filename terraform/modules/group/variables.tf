variable "ya_folder_id" {
  type        = string
  description = "yandex cloud folder id"
}

variable "ya_service_account_id" {
  type        = string
  description = "yandex cloud service account, that be attached to group"
}

variable "network_id" {
  type        = string
  description = "VPC network"
}
variable "subnet_id" {
  type        = string
  description = "VPC subnetwork. typically, private"
}

variable "image_family" {
  type        = string
  description = "group image family"
}
variable "image_id" {
  type        = string
  description = "concrete image id"
  default     = ""
}

variable "user_data" {
  type        = string
  description = "cloud init metadata"
}
