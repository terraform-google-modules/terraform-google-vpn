# Upgrading to v3.0.0

The v3.0 release contains backwards-incompatible changes.

This update requires upgrading the minimum provider version `4.74`.

### [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0 is required as `peer_external_gateway`, `router_advertise_config`, `tunnels` and its nested attributes and objects are made optional
Since [optional attributes](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes) is a version 1.3 feature, the configuration will fail if the pinned version is < 1.3..
