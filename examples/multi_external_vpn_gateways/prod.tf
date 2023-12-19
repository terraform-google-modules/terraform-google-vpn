/**
 * Copyright 2020 Google LLC
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

# Creating an external VPN gateway IP for DC1
resource "google_compute_external_vpn_gateway" "external_gateway1" {
  provider        = google-beta
  name            = "vpn-peering-gw1"
  project         = var.prod_project_id
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "My VPN peering gateway1"

  interface {
    id         = 0
    ip_address = "8.8.8.8"
  }
}

# Creating an external VPN gateway IP for DC2
resource "google_compute_external_vpn_gateway" "external_gateway2" {
  provider        = google-beta
  name            = "vpn-peering-gw2"
  project         = var.prod_project_id
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "My VPN peering gateway2"

  interface {
    id         = 0
    ip_address = "8.4.4.8"
  }
}

# In order to have successful setup, you need to configure the On-Premise
# VPN by this below tunnels configuration.

module "vpn-ha-to-onprem" {
  source  = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version = "~> 4.0"

  project_id = var.prod_project_id
  region     = var.region
  network    = var.prod_network_self_link
  name       = "prod-to-onprem"
  router_asn = 64512

  tunnels = {
    # DC1 remote tunnel with specific external VPN gateway
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64515
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_self_link = google_compute_external_vpn_gateway.external_gateway1.self_link
      peer_external_gateway_interface = 0
      shared_secret                   = "Secret1"
    }

    # DC2 remote tunnel with specific external VPN gateway
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64516
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_self_link = google_compute_external_vpn_gateway.external_gateway2.self_link
      peer_external_gateway_interface = 0
      shared_secret                   = "Secret2"
    }
  }
}
