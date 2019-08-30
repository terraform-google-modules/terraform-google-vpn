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

##To MGMT VPC
resource "google_compute_router" "cr-uscentral1-to-mgt-vpc-01" {
  name    = "cr-uscentral1-to-mgt-vpc-tunnels-01"
  region  = "us-central1"
  network = var.prod_network
  project = var.prod_project_id

  bgp {
    asn = "64515"
  }
}

resource "google_compute_router" "cr-uscentral1-to-mgt-vpc-02" {
  name    = "cr-uscentral1-to-mgt-vpc-tunnels-02"
  region  = "us-central1"
  network = var.prod_network
  project = var.prod_project_id

  bgp {
    asn = "64520"
  }
}

module "vpn-gw-us-ce1-prd-mgt-internal-01" {
  source             = "../../"
  project_id         = var.prod_project_id
  network            = var.prod_network
  region             = "us-central1"
  gateway_name       = "vpn-gw-us-ce1-prd-mgt-internal-01"
  tunnel_name_prefix = "vpn-tn-us-ce1-prd-mgt-internal-01-tunnel"
  shared_secret      = "secrets"
  tunnel_count       = 2
  peer_ips           = [module.vpn-gw-us-ce1-mgt-prd-internal-01.gateway_ip, module.vpn-gw-us-ce1-mgt-prd-internal-02.gateway_ip]

  cr_name                  = "cr-uscentral1-to-mgt-vpc-tunnels-01"
  cr_enabled               = true
  bgp_cr_session_range     = ["169.254.0.1/30", "169.254.0.21/30"]
  bgp_remote_session_range = ["169.254.0.2", "169.254.0.22"]
  peer_asn                 = ["64516", "64521"]
}

module "vpn-gw-us-ce1-prd-mgt-internal-02" {
  source             = "../../"
  project_id         = var.prod_project_id
  network            = var.prod_network
  region             = "us-central1"
  gateway_name       = "vpn-gw-us-ce1-prd-mgt-internal-02"
  tunnel_name_prefix = "vpn-tn-us-ce1-prd-mgt-internal-02-tunnel"
  shared_secret      = "secrets"
  tunnel_count       = 2
  peer_ips           = [module.vpn-gw-us-ce1-mgt-prd-internal-02.gateway_ip, module.vpn-gw-us-ce1-mgt-prd-internal-01.gateway_ip]

  cr_name                  = "cr-uscentral1-to-mgt-vpc-tunnels-02"
  cr_enabled               = true
  bgp_cr_session_range     = ["169.254.0.5/30", "169.254.0.25/30"]
  bgp_remote_session_range = ["169.254.0.6", "169.254.0.26"]
  peer_asn                 = ["64521", "64516"]
}

module "vpn-gw-us-we1-prd-mgt-internal" {
  source             = "../../"
  project_id         = var.prod_project_id
  network            = var.prod_network
  region             = "us-west1"
  gateway_name       = "vpn-gw-us-we1-prd-mgt-internal"
  tunnel_name_prefix = "vpn-tn-us-we1-prd-mgt-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.vpn-gw-us-we1-mgt-prd-internal.gateway_ip]

  route_priority = 1000
  remote_subnet  = ["10.17.32.0/20", "10.17.16.0/20"]
}

