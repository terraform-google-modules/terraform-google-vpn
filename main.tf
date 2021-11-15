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

locals {
  tunnel_name_prefix    = var.tunnel_name_prefix != "" ? var.tunnel_name_prefix : "${var.network}-${var.gateway_name}-tunnel"
  default_shared_secret = var.shared_secret != "" ? var.shared_secret : random_id.ipsec_secret.b64_url
}

# For VPN gateways with static routing
## Create Route (for static routing gateways)
resource "google_compute_route" "route" {
  count      = !var.cr_enabled ? var.tunnel_count * length(var.remote_subnet) : 0
  name       = "${google_compute_vpn_gateway.vpn_gateway.name}-tunnel${floor(count.index / length(var.remote_subnet)) + 1}-route${count.index % length(var.remote_subnet) + 1}"
  network    = var.network
  project    = var.project_id
  dest_range = var.remote_subnet[count.index % length(var.remote_subnet)]
  priority   = var.route_priority
  tags       = var.route_tags

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-static[floor(count.index / length(var.remote_subnet))].self_link

  depends_on = [google_compute_vpn_tunnel.tunnel-static]
}

# For VPN gateways routing through BGP and Cloud Routers
## Create Router Interfaces
resource "google_compute_router_interface" "router_interface" {
  count      = var.cr_enabled ? var.tunnel_count : 0
  name       = "interface-${local.tunnel_name_prefix}-${count.index}"
  router     = var.cr_name
  region     = var.region
  ip_range   = var.bgp_cr_session_range[count.index]
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-dynamic[count.index].name
  project    = var.project_id

  depends_on = [google_compute_vpn_tunnel.tunnel-dynamic]
}

## Create Peers
resource "google_compute_router_peer" "bgp_peer" {
  count                     = var.cr_enabled ? var.tunnel_count : 0
  name                      = "bgp-session-${local.tunnel_name_prefix}-${count.index}"
  router                    = var.cr_name
  region                    = var.region
  peer_ip_address           = var.bgp_remote_session_range[count.index]
  peer_asn                  = var.peer_asn[count.index]
  advertised_route_priority = var.advertised_route_priority
  interface                 = "interface-${local.tunnel_name_prefix}-${count.index}"
  project                   = var.project_id

  depends_on = [google_compute_router_interface.router_interface]
}

