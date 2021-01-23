output "master_external_ip" {
  description = "master public ip"
  value       = module.master.external_ip
}

output "master_internal_ip" {
  description = "master internal ip"
  value       = module.master.internal_ip
}

output "worker_instances" {
  description = "created instances with theirs internal addresses"
  value       = module.workers_group.instances
}

output "swarm_token" {
  description = "swarm token for joining as worker"
  value       = module.master.swarm_token
}
