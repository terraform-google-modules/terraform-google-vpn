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

variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created"
}

variable "network" {
  type        = string
  description = "The name of VPC being created"
}

variable "region" {
  type        = string
  description = "The region in which you want to create the VPN gateway"
}

variable "gateway_name" {
  type        = string
  description = "The name of VPN gateway"
  default     = "test-vpn"
}

variable "tunnel_count" {
  type        = number
  description = "The number of tunnels from each VPN gw (default is 1)"
  default     = 1
}

variable "tunnel_name_prefix" {
  type        = string
  description = "The optional custom name of VPN tunnel being created"
  default     = ""
}

variable "local_traffic_selector" {
  description = <<EOD
Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD


  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "remote_traffic_selector" {
  description = <<EOD
Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD


  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "peer_ips" {
  type        = list(string)
  description = "IP address of remote-peer/gateway"
}

variable "remote_subnet" {
  description = "remote subnet ip range in CIDR format - x.x.x.x/x"
  type        = list(string)
  default     = []
}

variable "shared_secret" {
  type        = string
  description = "Please enter the shared secret/pre-shared key"
  default     = ""
}

variable "route_priority" {
  description = "Priority for static route being created"
  default     = 1000
}

variable "cr_name" {
  type        = string
  description = "The name of cloud router for BGP routing"
  default     = ""
}

variable "cr_enabled" {
  type        = bool
  description = "If there is a cloud router for BGP routing"
  default     = false
}

variable "peer_asn" {
  type        = list(string)
  description = "Please enter the ASN of the BGP peer that cloud router will use"
  default     = ["65101"]
}

variable "bgp_cr_session_range" {
  type        = list(string)
  description = "Please enter the cloud-router interface IP/Session IP"
  default     = ["169.254.1.1/30", "169.254.1.5/30"]
}

variable "bgp_remote_session_range" {
  type        = list(string)
  description = "Please enter the remote environments BGP Session IP"
  default     = ["169.254.1.2", "169.254.1.6"]
}

variable "advertised_route_priority" {
  description = "Please enter the priority for the advertised route to BGP peer(default is 100)"
  default     = 100
}

variable "ike_version" {
  type        = number
  description = "Please enter the IKE version used by this tunnel (default is IKEv2)"
  default     = 2
}

