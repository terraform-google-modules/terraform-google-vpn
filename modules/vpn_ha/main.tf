
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

locals {
  router = (
    var.router_name == ""
    ? google_compute_router.router[0].name
    : var.router_name
  )
  peer_external_gateway = (
    var.peer_external_gateway != null
    ? google_compute_external_vpn_gateway.external_gateway[0].self_link
    : null
  )
  secret = random_id.secret.b64_url
  vpn_gateway_self_link = (
    var.create_vpn_gateway
    ? google_compute_ha_vpn_gateway.ha_gateway[0].self_link
    : var.vpn_gateway_self_link
  )
}

resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  count      = var.create_vpn_gateway == true ? 1 : 0
  name       = var.name
  project    = var.project_id
  region     = var.region
  network    = var.network
  stack_type = var.stack_type
  labels     = var.labels
  dynamic "vpn_interfaces" {
    for_each = { for idx, val in var.interconnect_attachment : idx => val }
    content {
      id                      = vpn_interfaces.key
      interconnect_attachment = vpn_interfaces.value
    }
  }
}

resource "google_compute_external_vpn_gateway" "external_gateway" {
  count           = var.peer_external_gateway != null ? 1 : 0
  name            = var.peer_external_gateway.name != null ? var.peer_external_gateway.name : "external-${var.name}"
  project         = var.project_id
  redundancy_type = var.peer_external_gateway.redundancy_type
  description     = var.external_vpn_gateway_description
  labels          = var.labels
  dynamic "interface" {
    for_each = var.peer_external_gateway.interfaces
    content {
      id         = interface.value.id
      ip_address = interface.value.ip_address
    }
  }
}

resource "google_compute_router" "router" {
  count   = var.router_name == "" ? 1 : 0
  name    = "vpn-${var.name}"
  project = var.project_id
  region  = var.region
  network = var.network
  bgp {
    advertise_mode = (
      var.router_advertise_config == null
      ? null
      : var.router_advertise_config.mode
    )
    advertised_groups = (
      var.router_advertise_config == null ? null : (
        var.router_advertise_config.mode != "CUSTOM"
        ? null
        : var.router_advertise_config.groups
      )
    )
    dynamic "advertised_ip_ranges" {
      for_each = (
        var.router_advertise_config == null ? {} : (
          var.router_advertise_config.mode != "CUSTOM"
          ? {}
          : var.router_advertise_config.ip_ranges
        )
      )
      iterator = range
      content {
        range       = range.key
        description = range.value
      }
    }
    asn                = var.router_asn
    keepalive_interval = var.keepalive_interval
  }
}

resource "google_compute_router_peer" "bgp_peer" {
  provider        = google-beta
  for_each        = var.tunnels
  region          = var.region
  project         = var.project_id
  name            = each.value.bgp_session_name != null ? each.value.bgp_session_name : "${var.name}-${each.key}"
  router          = local.router
  peer_ip_address = each.value.bgp_peer.address
  peer_asn        = each.value.bgp_peer.asn
  custom_learned_route_priority = each.value.custom_learned_route_priority == null ? null : each.value.custom_learned_route_priority
  ip_address      = each.value.bgp_peer_options == null ? null : each.value.bgp_peer_options.ip_address
  advertised_route_priority = (
    each.value.bgp_peer_options == null ? var.route_priority : (
      each.value.bgp_peer_options.route_priority == null
      ? var.route_priority
      : each.value.bgp_peer_options.route_priority
    )
  )
  advertise_mode = (
    each.value.bgp_peer_options == null ? null : each.value.bgp_peer_options.advertise_mode
  )
  advertised_groups = (
    each.value.bgp_peer_options == null ? null : (
      each.value.bgp_peer_options.advertise_mode != "CUSTOM"
      ? null
      : each.value.bgp_peer_options.advertise_groups
    )
  )
  import_policies = (
    each.value.bgp_peer_options == null ? null : each.value.bgp_peer_options.import_policies
  )
  export_policies = (
    each.value.bgp_peer_options == null ? null : each.value.bgp_peer_options.export_policies
  )
  dynamic "advertised_ip_ranges" {
    for_each = (
      each.value.bgp_peer_options == null ? {} : (
        each.value.bgp_peer_options.advertise_mode != "CUSTOM"
        ? {}
        : each.value.bgp_peer_options.advertise_ip_ranges
      )
    )
    iterator = range
    content {
      range       = range.key
      description = range.value
    }
  }

  dynamic "custom_learned_ip_ranges" {
    for_each = (
      each.value.bgp_peer_options == null ? {} : (
       each.value.bgp_peer_options.custom_learned_ip_ranges
      )
    )
    iterator = range
    content {
      range       = range.key
    }
  }
  interface = google_compute_router_interface.router_interface[each.key].name
}

resource "google_compute_router_interface" "router_interface" {
  for_each   = var.tunnels
  project    = var.project_id
  region     = var.region
  name       = each.value.bgp_session_name != null ? each.value.bgp_session_name : "${var.name}-${each.key}"
  router     = local.router
  ip_range   = each.value.bgp_session_range == "" ? null : each.value.bgp_session_range
  vpn_tunnel = google_compute_vpn_tunnel.tunnels[each.key].name
}

resource "google_compute_vpn_tunnel" "tunnels" {
  for_each                        = var.tunnels
  project                         = var.project_id
  region                          = var.region
  name                            = "${var.name}-${each.key}"
  router                          = local.router
  peer_external_gateway           = each.value.peer_external_gateway_self_link != null ? each.value.peer_external_gateway_self_link : local.peer_external_gateway
  peer_external_gateway_interface = each.value.peer_external_gateway_interface
  peer_gcp_gateway                = var.peer_gcp_gateway
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  ike_version                     = each.value.ike_version
  shared_secret                   = each.value.shared_secret == "" ? local.secret : each.value.shared_secret
  vpn_gateway                     = local.vpn_gateway_self_link
  labels                          = var.labels
}

resource "random_id" "secret" {
  byte_length = var.ipsec_secret_length
}
