variable "ya_folder_id" {
  type        = string
  description = "yandex cloud folder id"
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

variable "ssh_private_key" {
  type        = string
  description = "content of ssh private key for connecting to instance"
}

variable "subnet_id" {
  type        = string
  description = "VPC subnetwork. typically, public"
}

variable "user_data" {
  type        = string
  description = "cloud init metadata"
}
