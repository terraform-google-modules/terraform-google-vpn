# Upgrading to VPN v2.0

The v2.0 release of the VPN module is a backward incompatible release.
It only affects configurations which utilize dynamic routes with a
Cloud Router.

## Upgrade Instructions

In previous releases, using a Cloud Router required a hard-coded input
of the Cloud Router name due to the use of the `cr_name` variable in an
internal `count` expression which determines if a Cloud Router is to
be used.

```hcl
resource "google_compute_router" "cr_central1_to_mgt_vpc" {
  name    = "cr-uscentral1-to-mgt-vpc-tunnels"
  region  = "us-central1"
  network = var.prod_network
  project = var.prod_project_id

  bgp {
    asn   = "64515"
  }
}

module "vpn_dynamic" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.0"

  project_id               = var.project_id
  network                  = var.network
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
```

In the v2.0.0 release, the new `cr_enabled` variable is used to
determine if a Cloud Router is to be used, which allows `cr_name` to
support dynamic references to Cloud Router names.

```diff
 resource "google_compute_router" "cr_central1_to_mgt_vpc" {
   name    = "cr-uscentral1-to-mgt-vpc-tunnels"
   region  = "us-central1"
   network = var.prod_network
   project = var.prod_project_id

   bgp {
     asn   = "64515"
   }
 }

 module "vpn-module-dynamic" {
   source  = "terraform-google-modules/vpn/google"
   version = "~> 2.0"

   project_id               = "var.project_id"
   network                  = "var.network"
   region                   = "us-west1"
   gateway_name             = "vpn-gw-us-we1-dynamic"
   tunnel_name_prefix       = "vpn-tn-us-we1-dynamic"
   shared_secret            = "secrets"
   tunnel_count             = 2
   peer_ips                 = ["1.1.1.1","2.2.2.2"]

+  cr_enabled               = true
-  cr_name                  = "cr-uscentral1-to-mgt-vpc-tunnels"
+  cr_name                  = google_compute_router.cr_central1_to_mgt_vpc.name
   bgp_cr_session_range     = ["169.254.0.1/30", "169.254.0.3/30"]
   bgp_remote_session_range = ["169.254.0.2", "169.254.0.4"]
   peer_asn                 = ["64516", "64517"]
 }
```
