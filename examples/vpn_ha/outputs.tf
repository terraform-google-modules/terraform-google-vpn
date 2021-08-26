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

output "mgt_gateway_name" {
  description = "Mgt VPN gateway name."
  value       = module.vpn-ha-to-prod.name
}

output "prod_gateway_name" {
  description = "Prod VPN gateway name."
  value       = module.vpn-ha-to-mgmt.name
}

output "prod_tunnel_names" {
  description = "Prod VPN tunnel names."
  value       = module.vpn-ha-to-mgmt.tunnel_names
  sensitive   = true
}

output "mgt_tunnel_names" {
  description = "Mgt VPN tunnel names."
  value       = module.vpn-ha-to-prod.tunnel_names
  sensitive   = true
}

