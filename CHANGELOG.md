
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Public API

The purpose of this section is to declare the public API of this project as required by  [item 1 of semantic versioning specification](https://semver.org/spec/v2.0.0.html#spec-item-1).

The public API for this project is defined by the files `docker-compose.playwright.yaml` and `install.yaml`.

------


## [2.0.1](https://github.com/julienloizelet/ddev-playwright/releases/tag/v2.0.1) - 2023-07-10
[_Compare with previous release_](https://github.com/julienloizelet/ddev-playwright/compare/v2.0.0...v2.0.1)


### Fixed

- Add release test

---



## [2.0.0](https://github.com/julienloizelet/ddev-playwright/releases/tag/v2.0.0) - 2023-06-14
[_Compare with previous release_](https://github.com/julienloizelet/ddev-playwright/compare/v1.0.2...v2.0.0)


### Changed

- Change `working_dir` to `/var/www/html` in `docker-compose.playwright.yaml` ([@see #5](https://github.com/julienloizelet/ddev-playwright/pull/5))

### Added

- Add `kasmVNC` service for Playwright headed test ([@see #5](https://github.com/julienloizelet/ddev-playwright/pull/5))
- Add custom commands `ddev playwright` and `ddev playwright-install` ([@see #5](https://github.com/julienloizelet/ddev-playwright/pull/5))


---



## [1.0.2](https://github.com/julienloizelet/ddev-playwright/releases/tag/v1.0.2) - 2023-06-12
[_Compare with previous release_](https://github.com/julienloizelet/ddev-playwright/compare/v1.0.1...v1.0.2)

### Fixed

- Fix docker-compose file


---


## [1.0.1](https://github.com/julienloizelet/ddev-playwright/releases/tag/v1.0.1) - 2023-02-07
[_Compare with previous release_](https://github.com/julienloizelet/ddev-playwright/compare/v1.0.0...v1.0.1)

### Fixed

- Fix release test


---

## [1.0.0](https://github.com/julienloizelet/ddev-playwright/releases/tag/v1.0.0) - 2023-02-07
[_Compare with previous release_](https://github.com/julienloizelet/ddev-playwright/compare/v0.0.1...v1.0.0)

### Changed

- Change version to `1.0.0`: first stable release


---


## [0.0.1](https://github.com/julienloizelet/ddev-playwright/releases/tag/v0.0.1) - 2023-02-07
### Added
- Initial release

