output "instances" {
  description = "created instances with theirs internal addresses"

  value = {
    for inst in yandex_compute_instance_group.workers_group.instances :
    inst.name => (length(inst.network_interface) > 0 ? inst.network_interface[0].ip_address : "null")
  }
}
