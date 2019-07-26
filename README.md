# Terraform Google Cloud Platform - [VPN Module](https://registry.terraform.io/modules/terraform-google-modules/vpn/google)

This modules makes it easy to set up VPN connectivity in GCP by defining your gateways and tunnels in a concise syntax.

It supports creating:

- A Google VPN Gateway
- Tunnels connecting the gateway to defined peers
- Static routes for subnets across tunnel -or- dynamic routes with cloud router

## Compatibility

 This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
  and need a Terraform 0.11.x-compatible version of this module, the last released version intended for
  Terraform 0.11.x is [0.3.0](https://registry.terraform.io/modules/terraform-google-modules/vpn/google/0.3.0).

## Usage
You can go to the examples folder, however the usage of the module could be like this in your own main.tf file:

```hcl
resource "google_compute_router" "cr-central1-to-mgt-vpc" {
  name    = "cr-uscentral1-to-mgt-vpc-tunnels"
  region  = "us-central1"
  network = "${var.prod_network}"
  project = "${var.prod_project_id}"

  bgp {
    asn   = "64515"
  }
}

module "vpn-module-dynamic" {
  source  = "terraform-google-modules/vpn/google"
  version = "0.2.0"

  project_id               = "${var.project_id}"
  network                  = "${var.network}"
  region                   = "us-west1"
  gateway_name             = "vpn-gw-us-we1-dynamic"
  tunnel_name_prefix       = "vpn-tn-us-we1-dynamic"
  shared_secret            = "secrets"
  tunnel_count             = 2
  peer_ips                 = ["1.1.1.1","2.2.2.2"]

  cr_name                  = "cr-uscentral1-to-mgt-vpc-tunnels"
  bgp_cr_session_range     = ["169.254.0.1/30", "169.254.0.3/30"]
  bgp_remote_session_range = ["169.254.0.2", "169.254.0.4"]
  peer_asn                 = ["64516", "64517"]
}

module "vpn-module-static" {
  source  = "terraform-google-modules/vpn/google"
  version = "0.2.0"

  project_id         = "${var.project_id}"
  network            = "${var.network}"
  region             = "us-west1"
  gateway_name       = "vpn-gw-us-we1-static"
  tunnel_name_prefix = "vpn-tn-us-we1-static"
  shared_secret      = "secrets"
  tunnel_count       = 2
  peer_ips           = ["1.1.1.1","2.2.2.2"]

  route_priority     = 1000
  remote_subnet      = ["10.200.10.0/24","10.200.20.0/24"]
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project_id | The ID of the project where this VPC will be created | string | - | yes |
| network | The name of the network being created | string | - | yes |
| region | The region where the gateway and tunnels are going to be created | string | - | yes |
| gateway_name | The name of the VPN gateway being created | list | - | yes |
| tunnel_name_prefix | The prefix used for the tunnel names. If more than one tunnel_count is specified, the tunnel_count is appended to the end of the tunnel prefix | string | - | yes |
| tunnel_count | The amount of tunnels attached to this gateway | int | 1 | no |
| peer_ips | List of peer IP's to use, needs a peer IP for each tunnel in tunnel_count. The first peer IP attaches to tunnel #1, second peer IP attaches to tunnel #2, and so on | list | - | yes |
| ike_version | Sets the IKE version to use with the tnnels. Defaults to IKEv2 | int | 2 | no |

Depending on if the VPN tunnel(s) will be using dynamic or static routing, different variables will need to be used in the module. For dynamic routing, please use the following variables. In addition, a cloud router resource will need to be created outside of the module to be leveraged by the gateway. (reference examples for more info)

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cr_name | Name of cloud router that is being used | string | - | yes |
| bgp_cr_session_range | Source IP and range of cloud router BGP session. List of IP and ranges to use, needs an IP/range for each tunnel in tunnel_count. First IP/range is used for BGP session of tunnel #1, second IP/range is used for BGP session of tunnel #2, and so on | list | - | yes |
| bgp_remote_session_range | Remote peer IP of cloud router BGP session. List of IP's to use, needs an IP/range for each tunnel in tunnel_count. First IP/range is used for BGP session of tunnel #1, second IP/range is used for BGP session of tunnel #2, and so on | list | - | yes |
| peer_asn | ASN number of peer for cloud router BGP session. List of ASN's to use, needs an ASN for each tunnel in tunnel_count. First ASN is used for BGP session of tunnel #1, second ASN is used for BGP session of tunnel #2, and so on | list | - | yes |
| advertised_route_priority | The priority of routes advertised to the BGP peers | int | 100 | no |


For static routing, please use the following variables:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| route_priority | The priority for static routes being added to VPC | int | 1000 | no |
| remote_subnet | List of IP ranges that will be accessible over this VPN gateway. A route is created for each range in this list with next hop as VPN tunnels | list | - | yes |
| local_traffic_selector | Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway. Value should be list of CIDR formatted strings and ranges should be disjoint | list | ["0.0.0.0/0"] | no |
| remote_traffic_selector | Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway. Value should be list of CIDR formatted strings and ranges should be disjoint | list | ["0.0.0.0/0"] | no |

## Outputs
Please refer the /outputs.tf file for the outputs that you can get with the `terraform output` command

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following roles:
- roles/compute.networkAdmin on the organization

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:
- Compute Engine API - compute.googleapis.com

## Development
### File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /main.tf: main file for this module, contains the routing resources
- /gateway.tf: contains the gateway resources
- /tunnel.tf: contains the tunnel resources
- /forwarding-rule.tf: contains the forwarding rules
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /README.md: this file
