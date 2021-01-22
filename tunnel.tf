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

# Creating the VPN tunnel
resource "random_id" "ipsec_secret" {
  byte_length = 8
}

resource "google_compute_vpn_tunnel" "tunnel-static" {
  count         = !var.cr_enabled ? var.tunnel_count : 0
  name          = var.tunnel_count == 1 ? format("%s-%s", local.tunnel_name_prefix, "1") : format("%s-%d", local.tunnel_name_prefix, count.index + 1)
  region        = var.region
  project       = var.project_id
  peer_ip       = var.peer_ips[count.index]
  shared_secret = local.default_shared_secret

  target_vpn_gateway      = google_compute_vpn_gateway.vpn_gateway.self_link
  local_traffic_selector  = var.local_traffic_selector
  remote_traffic_selector = var.remote_traffic_selector

  ike_version = var.ike_version

  depends_on = [
    google_compute_forwarding_rule.vpn_esp,
    google_compute_forwarding_rule.vpn_udp500,
    google_compute_forwarding_rule.vpn_udp4500,
  ]
}

resource "google_compute_vpn_tunnel" "tunnel-dynamic" {
  count         = var.cr_enabled ? var.tunnel_count : 0
  name          = var.tunnel_count == 1 ? format("%s-%s", local.tunnel_name_prefix, "1") : format("%s-%d", local.tunnel_name_prefix, count.index + 1)
  region        = var.region
  project       = var.project_id
  peer_ip       = var.peer_ips[count.index]
  shared_secret = local.default_shared_secret

  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway.self_link

  router      = var.cr_name
  ike_version = var.ike_version

  depends_on = [
    google_compute_forwarding_rule.vpn_esp,
    google_compute_forwarding_rule.vpn_udp500,
    google_compute_forwarding_rule.vpn_udp4500,
  ]
}

