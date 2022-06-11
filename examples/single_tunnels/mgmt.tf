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

module "vpn-gw-us-we1-mgt-prd-internal" {
  source             = "../../"
  project_id         = var.mgt_project_id
  network            = var.mgt_network
  region             = "us-west1"
  gateway_name       = "vpn-gw-us-we1-mgt-prd-internal"
  tunnel_name_prefix = "vpn-tn-us-we1-mgt-prd-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.vpn-gw-us-we1-prd-mgt-internal.gateway_ip]

  route_priority = 1000
  remote_subnet  = ["10.17.0.0/22", "10.16.80.0/24"]
}
