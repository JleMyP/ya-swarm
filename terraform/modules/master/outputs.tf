output "external_ip" {
  description = "master public ip"
  value       = yandex_compute_instance.master.network_interface[0].nat_ip_address
}

output "internal_ip" {
  description = "master internal ip"
  value       = yandex_compute_instance.master.network_interface[0].ip_address
}

output "swarm_token" {
  description = "swarm token for joining as worker"
  value       = data.external.swarm_token.result.token
}
