/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "project_id" {
  description = "The Project-ID"
  value       = google_compute_vpn_gateway.vpn_gateway.project
}

output "name" {
  description = "The name of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.name
}

output "gateway_self_link" {
  description = "The self-link of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.self_link
}

output "network" {
  description = "The name of the VPC"
  value       = google_compute_vpn_gateway.vpn_gateway.network
}

output "gateway_ip" {
  description = "The VPN Gateway Public IP"
  value       = google_compute_address.vpn_gw_ip.address
}

output "vpn_tunnels_names-static" {
  description = "The VPN tunnel name is"
  value       = google_compute_vpn_tunnel.tunnel-static.*.name
}

output "vpn_tunnels_self_link-static" {
  description = "The VPN tunnel self-link is"
  value       = google_compute_vpn_tunnel.tunnel-static.*.self_link
}

output "ipsec_secret-static" {
  description = "The secret"
  value       = google_compute_vpn_tunnel.tunnel-static.*.shared_secret
}

output "vpn_tunnels_names-dynamic" {
  description = "The VPN tunnel name is"
  value       = google_compute_vpn_tunnel.tunnel-dynamic.*.name
}

output "vpn_tunnels_self_link-dynamic" {
  description = "The VPN tunnel self-link is"
  value       = google_compute_vpn_tunnel.tunnel-dynamic.*.self_link
}

output "ipsec_secret-dynamic" {
  description = "The secret"
  value       = google_compute_vpn_tunnel.tunnel-dynamic.*.shared_secret
}
