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

# Assosciate external IP/Port-range to VPN-GW by using Forwarding rules
resource "google_compute_forwarding_rule" "vpn_esp" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_gw_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "vpn_udp500" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_gw_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "vpn_udp4500" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_gw_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

