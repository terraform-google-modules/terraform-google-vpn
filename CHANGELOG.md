# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
