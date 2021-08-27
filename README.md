# Terraform Google Cloud Platform - [VPN Module](https://registry.terraform.io/modules/terraform-google-modules/vpn/google)

This modules makes it easy to set up VPN connectivity in GCP by defining your gateways and tunnels in a concise syntax.

It supports creating:

- A Google VPN Gateway
- Tunnels connecting the gateway to defined peers
- Static routes for subnets across tunnel -or- dynamic routes with cloud router

If you want to deploy [HA VPN](https://cloud.google.com/vpn/docs/how-to/moving-to-ha-vpn) please refer to the [VPN HA Submodule](./modules/vpn_ha/)

## Compatibility

 This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
  and need a Terraform 0.11.x-compatible version of this module, the last released version intended for
  Terraform 0.11.x is [0.3.0](https://registry.terraform.io/modules/terraform-google-modules/vpn/google/0.3.0).

## Upgrading

The following guides are available to assist with upgrades:

- [1.X -> 2.0](./docs/upgrading_to_vpn_v2.0.md)

## Usage

You can go to the examples folder, however the usage of the module could be like this in your own main.tf file:

```hcl
resource "google_compute_router" "cr-uscentral1-to-prod-vpc" {
  name    = "cr-uscentral1-to-prod-vpc-tunnels"
  region  = "us-central1"
  network = "default"
  project = var.project_id

  bgp {
    asn = "64519"
  }
}

module "vpn-prod-internal" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0"

  project_id         = var.project_id
  network            = "default"
  region             = "us-west1"
  gateway_name       = "vpn-prod-internal"
  tunnel_name_prefix = "vpn-tn-prod-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = ["1.1.1.1", "2.2.2.2"]

  route_priority = 1000
  remote_subnet  = ["10.17.0.0/22", "10.16.80.0/24"]
}

module "vpn-manage-internal" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0"
  project_id         = var.project_id
  network            = "default"
  region             = "us-west1"
  gateway_name       = "vpn-manage-internal"
  tunnel_name_prefix = "vpn-tn-manage-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = ["1.1.1.1", "2.2.2.2"]

  route_priority = 1000
  remote_subnet  = ["10.17.32.0/20", "10.17.16.0/20"]
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Static vs Dynamic
Depending on if the VPN tunnel(s) will be using dynamic or static routing,
different variables will need to be used in the module.
References the variable descriptions below to determine the right configuration.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| advertised\_route\_priority | Please enter the priority for the advertised route to BGP peer(default is 100) | `number` | `100` | no |
| bgp\_cr\_session\_range | Please enter the cloud-router interface IP/Session IP | `list(string)` | <pre>[<br>  "169.254.1.1/30",<br>  "169.254.1.5/30"<br>]</pre> | no |
| bgp\_remote\_session\_range | Please enter the remote environments BGP Session IP | `list(string)` | <pre>[<br>  "169.254.1.2",<br>  "169.254.1.6"<br>]</pre> | no |
| cr\_enabled | If there is a cloud router for BGP routing | `bool` | `false` | no |
| cr\_name | The name of cloud router for BGP routing | `string` | `""` | no |
| gateway\_name | The name of VPN gateway | `string` | `"test-vpn"` | no |
| ike\_version | Please enter the IKE version used by this tunnel (default is IKEv2) | `number` | `2` | no |
| local\_traffic\_selector | Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway.<br>Value should be list of CIDR formatted strings and ranges should be disjoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| network | The name of VPC being created | `string` | n/a | yes |
| peer\_asn | Please enter the ASN of the BGP peer that cloud router will use | `list(string)` | <pre>[<br>  "65101"<br>]</pre> | no |
| peer\_ips | IP address of remote-peer/gateway | `list(string)` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `string` | n/a | yes |
| region | The region in which you want to create the VPN gateway | `string` | n/a | yes |
| remote\_subnet | remote subnet ip range in CIDR format - x.x.x.x/x | `list(string)` | `[]` | no |
| remote\_traffic\_selector | Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway.<br>Value should be list of CIDR formatted strings and ranges should be disjoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| route\_priority | Priority for static route being created | `number` | `1000` | no |
| route\_tags | A list of instance tags to which this route applies. | `list(string)` | `[]` | no |
| shared\_secret | Please enter the shared secret/pre-shared key | `string` | `""` | no |
| tunnel\_count | The number of tunnels from each VPN gw (default is 1) | `number` | `1` | no |
| tunnel\_name\_prefix | The optional custom name of VPN tunnel being created | `string` | `""` | no |
| vpn\_gw\_ip | Please enter the public IP address of the VPN Gateway, if you have already one. Do not set this variable to autocreate one | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_ip | The VPN Gateway Public IP |
| gateway\_self\_link | The self-link of the Gateway |
| ipsec\_secret-dynamic | The secret |
| ipsec\_secret-static | The secret |
| name | The name of the Gateway |
| network | The name of the VPC |
| project\_id | The Project-ID |
| vpn\_tunnels\_names-dynamic | The VPN tunnel name is |
| vpn\_tunnels\_names-static | The VPN tunnel name is |
| vpn\_tunnels\_self\_link-dynamic | The VPN tunnel self-link is |
| vpn\_tunnels\_self\_link-static | The VPN tunnel self-link is |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
- /modules/vpn_ha/: vpn ha submodule
- /README.md: this file
