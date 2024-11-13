# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.2.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v4.1.0...v4.2.0) (2024-11-12)


### Features

* Making IPSEC PSK length configurable ([#171](https://github.com/terraform-google-modules/terraform-google-vpn/issues/171)) ([0621d9c](https://github.com/terraform-google-modules/terraform-google-vpn/commit/0621d9c87bfd53680bebaa4d9863a735c2f99e26))

## [4.1.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v4.0.1...v4.1.0) (2024-09-11)


### Features

* **deps:** Update Terraform Google Provider to v6 (major) ([#166](https://github.com/terraform-google-modules/terraform-google-vpn/issues/166)) ([badb0d5](https://github.com/terraform-google-modules/terraform-google-vpn/commit/badb0d593a6d982806a3107581e309fc4a2936dc))

## [4.0.1](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v4.0.0...v4.0.1) (2024-07-25)


### Bug Fixes

* mark secret outputs sensitive for classic vpn Ref: [#158](https://github.com/terraform-google-modules/terraform-google-vpn/issues/158) ([#159](https://github.com/terraform-google-modules/terraform-google-vpn/issues/159)) ([c3c7812](https://github.com/terraform-google-modules/terraform-google-vpn/commit/c3c78122c572017e34231c813d56eb45534ddfd3))

## [4.0.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v3.1.1...v4.0.0) (2023-11-21)


### ⚠ BREAKING CHANGES

* migrate to GA Terraform Provider ([#134](https://github.com/terraform-google-modules/terraform-google-vpn/issues/134))

### Bug Fixes

* migrate to GA Terraform Provider ([#134](https://github.com/terraform-google-modules/terraform-google-vpn/issues/134)) ([b289d32](https://github.com/terraform-google-modules/terraform-google-vpn/commit/b289d32ceea6c03d653fa28fd352791bbbd464dc))

## [3.1.1](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v3.1.0...v3.1.1) (2023-10-31)


### Bug Fixes

* upgraded versions.tf to include minor bumps from tpg v5 ([#125](https://github.com/terraform-google-modules/terraform-google-vpn/issues/125)) ([72bb554](https://github.com/terraform-google-modules/terraform-google-vpn/commit/72bb5545228ec9643ba4428af599f9cdcffb8665))

## [3.1.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v3.0.1...v3.1.0) (2023-09-11)


### Features

* support multiple external VPN peering gateways ([#119](https://github.com/terraform-google-modules/terraform-google-vpn/issues/119)) ([c51aee7](https://github.com/terraform-google-modules/terraform-google-vpn/commit/c51aee7a43c520a7fdf11ec8023806c5bc6fbd30))

## [3.0.1](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v3.0.0...v3.0.1) (2023-08-17)


### Bug Fixes

* updated docs and variable description ([#117](https://github.com/terraform-google-modules/terraform-google-vpn/issues/117)) ([a6b543d](https://github.com/terraform-google-modules/terraform-google-vpn/commit/a6b543dea5d893d2549c46e76cfb51dd9750063b))

## [3.0.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v2.4.0...v3.0.0) (2023-07-25)


### ⚠ BREAKING CHANGES

* **TPG >= 4.74:** Added labels, update TPG and Terraform version requirements  ([#112](https://github.com/terraform-google-modules/terraform-google-vpn/issues/112))

### Features

* adds stack_type and an option to set the router name ([#110](https://github.com/terraform-google-modules/terraform-google-vpn/issues/110)) ([2382abd](https://github.com/terraform-google-modules/terraform-google-vpn/commit/2382abda421bafab111b13b83428c4e955f83dc1))
* **TPG >= 4.74:** Added labels, update TPG and Terraform version requirements  ([#112](https://github.com/terraform-google-modules/terraform-google-vpn/issues/112)) ([24a946c](https://github.com/terraform-google-modules/terraform-google-vpn/commit/24a946cf5d6cce4cc5c1398cc47f1e4d8dcf2de9))

## [2.4.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v2.3.1...v2.4.0) (2023-07-12)


### Features

* Add ip_address to bgp_peer_options in vpn_ha ([#100](https://github.com/terraform-google-modules/terraform-google-vpn/issues/100)) ([ca72e53](https://github.com/terraform-google-modules/terraform-google-vpn/commit/ca72e53e76336c53a2944a4ad1938225207483f2))
* adds variables required for FS ([#106](https://github.com/terraform-google-modules/terraform-google-vpn/issues/106)) ([442b40d](https://github.com/terraform-google-modules/terraform-google-vpn/commit/442b40dea068f1f9fe649ab5067df75a223cdd3e))

## [2.3.1](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v2.3.0...v2.3.1) (2022-12-29)


### Bug Fixes

* fixes lint issues and generates metadata ([#93](https://github.com/terraform-google-modules/terraform-google-vpn/issues/93)) ([0e3e19c](https://github.com/terraform-google-modules/terraform-google-vpn/commit/0e3e19c09971660a2905237bf58a294198a41a83))

## [2.3.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v2.2.0...v2.3.0) (2022-06-11)


### Features

* Add labels to VPN tunnel ([#76](https://github.com/terraform-google-modules/terraform-google-vpn/issues/76)) ([c2e563b](https://github.com/terraform-google-modules/terraform-google-vpn/commit/c2e563b4d5cf6b907898fd56f287fcbbb72274b5))


### Bug Fixes

* remove Classic VPN tunnels dynamic example ([#82](https://github.com/terraform-google-modules/terraform-google-vpn/issues/82)) ([2ab8e68](https://github.com/terraform-google-modules/terraform-google-vpn/commit/2ab8e68a0b8cc2508bfcab3aa9516ac2cbc9ed64))

## [2.2.0](https://github.com/terraform-google-modules/terraform-google-vpn/compare/v2.1.0...v2.2.0) (2022-01-18)


### Features

* update TPG version constraints to allow 4.0 ([#66](https://github.com/terraform-google-modules/terraform-google-vpn/issues/66)) ([a9bd3a7](https://github.com/terraform-google-modules/terraform-google-vpn/commit/a9bd3a70635e0229119618c8872e200369b8d6e2))


### Bug Fixes

* for_each can not receive null vpn_ha ([#67](https://github.com/terraform-google-modules/terraform-google-vpn/issues/67)) ([50120ec](https://github.com/terraform-google-modules/terraform-google-vpn/commit/50120ec35c0961d6cb79b2e640a7d154ebc341c5))

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v2.0.0...v2.1.0) (2021-09-23)


### Features

* added variable route_tags ([#61](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/61)) ([b85d3fa](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/b85d3fa02dcdb3b7c26254673301e7065b2af927))

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v1.5.0...v2.0.0) (2021-08-26)


### ⚠ BREAKING CHANGES

* The BGP session name now includes the tunnel name. This may cause recreation of the VPN tunnel.

### Bug Fixes

* Prefix BGP session name with tunnel name ([#58](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/58)) ([f8d08fd](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/f8d08fd34c34a9d6e01e510d9888616010e606de)), closes [#54](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/54)

## [1.5.0](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v1.4.1...v1.5.0) (2021-02-03)


### Features

* Add option to use an existing vpn_gateway ([#48](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/48)) ([712720a](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/712720a231bdb14b8ad5e310a5ff55284d27762e))


### Bug Fixes

* Mark certain output values as sensitive for TF 0.14 ([#51](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/51)) ([2e55b02](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/2e55b029f73de94ea5ad6e0d44a53a4897074652))

### [1.4.1](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v1.4.0...v1.4.1) (2020-08-28)


### Bug Fixes

* Fix numeric indexes for tunnels and subnets ([#43](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/43)) ([a78f08d](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/a78f08d598259b067452c0b6ef6806c0aceb26d5))

## [1.4.0](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v1.3.1...v1.4.0) (2020-05-28)


### Features

* enable usage of a already created public IP address([#40](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/40)) ([537d81e](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/537d81ee10a1e7b142cf5a1f84e9d1c31b22a9dd))

### [1.3.1](https://www.github.com/terraform-google-modules/terraform-google-vpn/compare/v1.3.0...v1.3.1) (2020-03-04)


### Bug Fixes

* Add the project argument to external_gateway ([#33](https://www.github.com/terraform-google-modules/terraform-google-vpn/issues/33)) ([a901ab7](https://www.github.com/terraform-google-modules/terraform-google-vpn/commit/a901ab7e89aed7dffddbcd90920918fac33a71be))

## [1.3.0] - 2020-03-03

### Features
- Added support for HA VPN through a [submodule](./modules/vpn_ha). [#32](https://github.com/terraform-google-modules/terraform-google-vpn/pull/32)

## [1.2.0] - 2019-11-20

### Added
- Added support for dynamic router [#16]

## [1.1.0] - 2019-08-21

### Change

- Added self-links of the tunnels and gateway to output [#17]

## [1.0.0] - 2019-07-26

### Change

- Upgraded for usage with terraform-0.12.x [#12]

## [0.3.0] - 2019-01-22

### Changed

- Made `local_traffic_selector` and `remote_traffic_selector` configurable.
- Update examples to use registry with versions
- Reorganize README

## [0.2.0] - 2019-01-17

### Changed

- Made `ike_version` configurable. #2

## [0.1.0] - 2019-01-17

### Added

- Initial module release.

[1.3.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-vpn/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-vpn/releases/tag/v0.1.0

[#12]: https://github.com/terraform-google-modules/terraform-google-vpn/pull/12
[#16]: https://github.com/terraform-google-modules/terraform-google-vpn/pull/16/
[#17]: https://github.com/terraform-google-modules/terraform-google-vpn/pull/17
