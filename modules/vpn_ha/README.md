# Cloud VPN HA Module
This module makes it easy to deploy either GCP-to-GCP or GCP-to-On-prem [Cloud HA VPN](https://cloud.google.com/vpn/docs/concepts/overview#ha-vpn).

## Examples

### GCP to GCP
```hcl
module "vpn_ha-1" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.3.0"
  project_id  = "<PROJECT_ID>"
  region  = "europe-west4"
  network         = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/network-1"
  name            = "net1-to-net-2"
  peer_gcp_gateway = module.vpn_ha-2.self_link
  router_asn = 64514
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.1.2/30"
      ike_version       = 2
      vpn_gateway_interface = 0
      peer_external_gateway_interface = null
      shared_secret     = ""
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.2.2/30"
      ike_version       = 2
      vpn_gateway_interface = 1
      peer_external_gateway_interface = null
      shared_secret     = ""
    }
  }
}

module "vpn_ha-2" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.3.0"
  project_id  = "<PROJECT_ID>"
  region  = "europe-west4"
  network         = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/local-network"
  name            = "net2-to-net1"
  router_asn = 64513
  peer_gcp_gateway = module.vpn_ha-1.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.1.1/30"
      ike_version       = 2
      vpn_gateway_interface = 0
      peer_external_gateway_interface = null
      shared_secret     = module.vpn_ha-1.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.2.1/30"
      ike_version       = 2
      vpn_gateway_interface = 1
      peer_external_gateway_interface = null
      shared_secret     = module.vpn_ha-1.random_secret
    }
  }
}
```
### GCP to on-prem

```hcl
module "vpn_ha" {
  source = "terraform-google-modules/vpn/google//modules/vpn_ha"
  project_id  = "<PROJECT_ID>"
  region  = "europe-west4"
  network         = "https://www.googleapis.com/compute/v1/projects/<PROJECT_ID>/global/networks/my-network"
  name            = "mynet-to-onprem"
  peer_external_gateway = {
      redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
      interfaces = [{
          id = 0
          ip_address = "8.8.8.8" # on-prem router ip address

      }]
  }
  router_asn = 64514
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.1.2/30"
      ike_version       = 2
      vpn_gateway_interface = 0
      peer_external_gateway_interface = 0
      shared_secret     = "mySecret"
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.2.2/30"
      ike_version       = 2
      vpn_gateway_interface = 1
      peer_external_gateway_interface = 0
      shared_secret     = "mySecret"
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | VPN gateway name, and prefix used for dependent resources. | string | n/a | yes |
| network | VPC used for the gateway and routes. | string | n/a | yes |
| peer\_external\_gateway | Configuration of an external VPN gateway to which this VPN is connected. | object | `"null"` | no |
| peer\_gcp\_gateway | Self Link URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected. | string | `"null"` | no |
| project\_id | Project where resources will be created. | string | n/a | yes |
| region | Region used for resources. | string | n/a | yes |
| route\_priority | Route priority, defaults to 1000. | number | `"1000"` | no |
| router\_advertise\_config | Router custom advertisement configuration, ip_ranges is a map of address ranges and descriptions. | object | `"null"` | no |
| router\_asn | Router ASN used for auto-created router. | number | `"64514"` | no |
| router\_name | Name of router, leave blank to create one. | string | `""` | no |
| tunnels | VPN tunnel configurations, bgp_peer_options is usually null. | object | `<map>` | no |

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
