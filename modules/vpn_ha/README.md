# Cloud VPN HA Module
This module makes it easy to deploy either GCP-to-GCP or GCP-to-On-prem [Cloud HA VPN](https://cloud.google.com/vpn/docs/concepts/overview#ha-vpn).

## Compatibility

This module is meant for use with Terraform 1.3+ and tested using Terraform 1.3+. If you find incompatibilities using Terraform >=1.3, please open an issue.

## Version

Current version is 1.0. Upgrade guides:

- [1.X -> 2.0.](/docs/upgrading_to_vpn_v2.0.md)
- [2.X -> 3.0.](/docs/upgrading_to_vpn_v3.0.md)
- [3.X -> 4.0.](/docs/upgrading_to_vpn_v4.0.md)

##  Module Format

```
module "vpn_ha" {
  source                           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version                          = "~> 4.0"
  project_id                       = <Project ID>
  region                           = "us-central1"
  network                          = <VPC-Network-Self-Link>
  name                             = "my-ha-vpn-gateway"

  create_vpn_gateway               = true
  vpn_gateway_self_link            = null

  router_name                      = "my-vpn-router"
  router_asn                       = 64514

  external_vpn_gateway_description = "My VPN peering gateway"
  peer_external_gateway            = {}
  tunnels = {

    tunel-0 = {

    }

    tunel-1 = {

    }

  }
}
```

See section [peer_external_gateway](#peer_external_gateway) and [tunnels](#tunnels) for details.

## Usage

### GCP to GCP
```hcl
module "vpn_ha-1" {
  source            = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version           = "~> 4.0"
  project_id        = "<PROJECT_ID>"
  region            = "europe-west4"
  network           = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/network-1"
  name              = "net1-to-net-2"
  peer_gcp_gateway  = module.vpn_ha-2.self_link
  router_asn        = 64514

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_ha-2" {
  source              = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version             = "~> 4.0"
  project_id          = "<PROJECT_ID>"
  region              = "europe-west4"
  network             = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/local-network"
  name                = "net2-to-net1"
  router_asn          = 64513
  peer_gcp_gateway    = module.vpn_ha-1.self_link

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      shared_secret                   = module.vpn_ha-1.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      shared_secret                   = module.vpn_ha-1.random_secret
    }

  }
}
```
### GCP to on-prem

```hcl
module "vpn_ha" {
  source                           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version                          = "~> 4.0"
  project_id                       = "<PROJECT_ID>"
  region                           = "europe-west4"
  network                          = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/my-network"
  name                             = "mynet-to-onprem"
  create_vpn_gateway               = true
  vpn_gateway_self_link            = null
  external_vpn_gateway_description = "My VPN peering gateway"
  router_name                      = "my-vpn-router"
  router_asn                       = 64515

  peer_external_gateway = {
    name            = "vpn-peering-gw"
    redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
    interfaces = [
      {
        id = 0
        ip_address = "8.8.8.8" # on-prem router ip address
      },
    ]
  }

  tunnels = {

    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_session_name                = "bgp-peer-0"
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 0
      shared_secret                   = "mySecret"
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_name                = "bgp-peer-1"
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 1
      shared_secret                   = "mySecret"
    }

  }
}
```

### GCP to on-prem using multiple external VPN gateways

```hcl

resource "google_compute_external_vpn_gateway" "external_gateway1" {
  name            = "vpn-peering-gw1"
  project         = "<PROJECT_ID>"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "My VPN peering gateway1"

  interface {
    id         = 0
    ip_address = "8.8.8.8"
  }
}

resource "google_compute_external_vpn_gateway" "external_gateway2" {
  name            = "vpn-peering-gw2"
  project         = "<PROJECT_ID>"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "My VPN peering gateway2"

  interface {
    id         = 0
    ip_address = "8.8.4.4"
  }
}

module "vpn_ha" {
  source                           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version                          = "~> 4.0"
  project_id                       = "<PROJECT_ID>"
  region                           = "europe-west4"
  network                          = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/my-network"
  name                             = "mynet-to-onprem"
  create_vpn_gateway               = true
  vpn_gateway_self_link            = null
  router_name                      = "my-vpn-router"
  router_asn                       = 64515

  tunnels = {

    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_session_name                = "bgp-peer-0"
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      peer_external_gateway_self_link = google_compute_external_vpn_gateway.external_gateway1.self_link # set a resource link
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 0
      shared_secret                   = "mySecret"
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_name                = "bgp-peer-1"
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      peer_external_gateway_self_link = google_compute_external_vpn_gateway.external_gateway2.self_link # set a resource link
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 1
      shared_secret                   = "mySecret"
    }

  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_vpn\_gateway | create a VPN gateway | `bool` | `true` | no |
| external\_vpn\_gateway\_description | An optional description of external VPN Gateway | `string` | `"Terraform managed external VPN gateway"` | no |
| interconnect\_attachment | URL of the interconnect attachment resource. When the value of this field is present, the VPN Gateway will be used for IPsec-encrypted Cloud Interconnect. | `list(string)` | `[]` | no |
| ipsec\_secret\_length | The lnegth the of shared secret for VPN tunnels | `number` | `8` | no |
| keepalive\_interval | The interval in seconds between BGP keepalive messages that are sent to the peer. | `number` | `20` | no |
| labels | Labels for vpn components | `map(string)` | `{}` | no |
| name | VPN gateway name, and prefix used for dependent resources. | `string` | n/a | yes |
| network | VPC used for the gateway and routes. | `string` | n/a | yes |
| peer\_external\_gateway | Configuration of an external VPN gateway to which this VPN is connected. | <pre>object({<br>    name            = optional(string)<br>    redundancy_type = optional(string)<br>    interfaces = list(object({<br>      id         = number<br>      ip_address = string<br>    }))<br>  })</pre> | `null` | no |
| peer\_gcp\_gateway | Self Link URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected. | `string` | `null` | no |
| project\_id | Project where resources will be created. | `string` | n/a | yes |
| region | Region used for resources. | `string` | n/a | yes |
| route\_priority | Route priority, defaults to 1000. | `number` | `1000` | no |
| router\_advertise\_config | Router custom advertisement configuration, ip\_ranges is a map of address ranges and descriptions. | <pre>object({<br>    groups    = list(string)<br>    ip_ranges = map(string)<br>    mode      = optional(string)<br>  })</pre> | `null` | no |
| router\_asn | Router ASN used for auto-created router. | `number` | `64514` | no |
| router\_name | Name of router, leave blank to create one. | `string` | `""` | no |
| stack\_type | The IP stack type will apply to all the tunnels associated with this VPN gateway. | `string` | `"IPV4_ONLY"` | no |
| tunnels | VPN tunnel configurations, bgp\_peer\_options is usually null. | <pre>map(object({<br>    bgp_peer = object({<br>      address = string<br>      asn     = number<br>    })<br>    bgp_session_name = optional(string)<br>    bgp_peer_options = optional(object({<br>      ip_address          = optional(string)<br>      advertise_groups    = optional(list(string))<br>      advertise_ip_ranges = optional(map(string))<br>      advertise_mode      = optional(string)<br>      route_priority      = optional(number)<br>      import_policies     = optional(list(string))<br>      export_policies     = optional(list(string))<br>    }))<br>    bgp_session_range               = optional(string)<br>    ike_version                     = optional(number)<br>    vpn_gateway_interface           = optional(number)<br>    peer_external_gateway_self_link = optional(string, null)<br>    peer_external_gateway_interface = optional(number)<br>    shared_secret                   = optional(string, "")<br>  }))</pre> | `{}` | no |
| vpn\_gateway\_self\_link | self\_link of existing VPN gateway to be used for the vpn tunnel. create\_vpn\_gateway should be set to false | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| external\_gateway | External VPN gateway resource. |
| gateway | HA VPN gateway resource. |
| name | VPN gateway name. |
| random\_secret | Generated secret. |
| router | Router resource (only if auto-created). |
| router\_name | Router name. |
| self\_link | HA VPN gateway self link. |
| tunnel\_names | VPN tunnel names. |
| tunnel\_self\_links | VPN tunnel self links. |
| tunnels | VPN tunnel resources. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## peer_external_gateway

# Format

```
  peer_external_gateway = {
    name             = "vpn-peering-gw"
    redundancy_type  = "SINGLE_IP_INTERNALLY_REDUNDANT"                   # can be SINGLE_IP_INTERNALLY_REDUNDANT, TWO_IPS_REDUNDANCY or FOUR_IPS_REDUNDANCY
    interfaces       = []
  }
```

# Examples

- Single Interfaces

```
  peer_external_gateway = {
    name            = "vpn-peering-gw"
    redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"                   # can be SINGLE_IP_INTERNALLY_REDUNDANT, TWO_IPS_REDUNDANCY or FOUR_IPS_REDUNDANCY
    interfaces = [
      {
        id         = 0
        ip_address = "130.100.0.10"
      },
    ]
  }
```

- Two Interfaces

```
  peer_external_gateway = {
    name            = "vpn-peering-gw"
    redundancy_type = "TWO_IPS_REDUNDANCY"                   # can be SINGLE_IP_INTERNALLY_REDUNDANT, TWO_IPS_REDUNDANCY or FOUR_IPS_REDUNDANCY
    interfaces = [
      {
        id         = 0
        ip_address = "130.100.0.10"
      },
      {
        id         = 1
        ip_address = "130.100.0.20"
      },
    ]
  }

```


- Four Interfaces

```
  peer_external_gateway = {
    name            = "vpn-peering-gw"
    redundancy_type = "FOUR_IPS_REDUNDANCY"                   # can be SINGLE_IP_INTERNALLY_REDUNDANT, TWO_IPS_REDUNDANCY or FOUR_IPS_REDUNDANCY
    interfaces = [
      {
        id         = 0
        ip_address = "130.100.0.10"
      },
      {
        id         = 1
        ip_address = "130.100.0.20"
      },
      {
        id         = 2
        ip_address = "130.100.0.100"
      },
      {
        id         = 3
        ip_address = "130.100.0.120"
      },
    ]
  }

```



## tunnels

# Format

```
  tunnels = {
    remote-0 = {

      bgp_peer = {
        address = "169.254.20.2" # Peer Router BGP IP address "169.254.20.2"
        asn     = 31898          # Peer Router ASN
      }

      bgp_session_name = "bgp-peer0"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"

        # advertise_ip_ranges is a map fo strings in format "ip-address" = "description of the IP address" ex: "199.36.153.4/30" = "restricted.googleapis.com IPs". advertise_mode should be "CUSTOM". Not needed if routes are advertised from cloud router.
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
        # ip_address          = optional(string)            # Optional GCP Router BGP IP address "169.254.20.1". Not needed. Will be pulled automatically from bgp_session_range
        # advertise_groups    = optional(list(string))
        # route_priority      = optional(number)
      }

      bgp_session_range               = "169.254.20.1/30"    # GCP BGP session IP address in this format: "169.254.X.X/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = random_string.secret.result

    }
  }
```

# Examples

- two tunnels

```
  tunnels = {
    remote-0 = {

      bgp_peer = {
        address = "169.254.20.2"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer0"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = random_string.secret.result

    }

    remote-1 = {

      bgp_peer = {
        address = "169.254.20.6"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer1"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.5/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 1
      shared_secret                   = random_string.secret.result
    }

  }
```

- Four tunnels

```
  tunnels = {
    remote-0-0 = {

      bgp_peer = {
        address = "169.254.20.2"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer-0-0"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = random_string.secret.result
    }

    remote-0-1 = {

      bgp_peer = {
        address = "169.254.20.6"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer-0-1"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.5/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 1
      shared_secret                   = random_string.secret.result
    }

    remote-1-0 = {

      bgp_peer = {
        address = "169.254.20.10"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer-1-0"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.9/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 2
      shared_secret                   = random_string.secret.result
    }

    remote-1-1 = {

      bgp_peer = {
        address = "169.254.20.14"
        asn     = 31898
      }

      bgp_session_name = "bgp-peer-1-1"

      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "199.36.153.4/30" = "restricted.googleapis.com IPs"
          "199.36.153.8/30" = "private.googleapis.com IPs"
          "10.200.5.0/32"   = "My GoogleAPIS PSC IP address"
          "10.10.10.0/24"   = "VPC IPs"
        }
      }

      bgp_session_range               = "169.254.20.13/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 3
      shared_secret                   = random_string.secret.result
    }

  }
```



## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 1.3+
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v5.7+

### Configure a Service Account
In order to execute this module you must have a Service Account with the following roles:
- roles/compute.networkAdmin on the organization

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:
- Compute Engine API - compute.googleapis.com

