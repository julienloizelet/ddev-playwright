[![tests](https://github.com/julienloizelet/ddev-playwright/actions/workflows/tests.yml/badge.svg)](https://github.com/julienloizelet/ddev-playwright/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2023.svg)

# ddev-playwright

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Introduction](#introduction)
- [Installation](#installation)
- [Basic usage](#basic-usage)
  - [Add-on commands for `@playwright/test` package](#add-on-commands-for-playwrighttest-package)
    - [`ddev playwright-install`](#ddev-playwright-install)
    - [`ddev playwright`](#ddev-playwright)
  - [VNC server](#vnc-server)
  - [Other commands](#other-commands)
- [Technical notes](#technical-notes)
  - [arm64](#arm64)
- [Thanks](#thanks)
- [Contribute](#contribute)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

[Playwright](https://playwright.dev) was created to accommodate the needs of end-to-end testing. 

This DDEV add-on allows you to use Playwright in a separate `playwright` service.


## Installation

```bash
ddev get julienloizelet/ddev-playwright
ddev restart
```

## Basic usage

### Add-on commands for `@playwright/test` package

#### `ddev playwright-install`

This command will install `playwright` and all dependencies in a folder defined by the environment variable `PLAYWRIGHT_TEST_DIR` of the `docker-compose.playwright.yaml` file. 

**Before running this command**, ensure that you have a `package.json` file in the `PLAYWRIGHT_TEST_DIR` folder. You will find an example of such a file in the `tests/project_root/tests/Playwright`folder of this repository. You will also find an example of a `playwright.config.js` file.

By default, `tests/Playwright` is used as `PLAYWRIGHT_TEST_DIR` value, but you can override this value to suit your need by creating a `docker-compose.override.yaml` in the `.ddev`  root directory with the following content: 

```yaml
services:
  playwright:
    environment:
      - PLAYWRIGHT_TEST_DIR=your/playwright/directory/path
```

You could also edit the value directly in the `docker-compose.playwright.yaml` file but you risk losing your changes every time you do a  `ddev get julienloizelet/ddev-playwright` (unless you delete the `#ddev-generated` line at the beginning of the file).

In addition, if there is a `.env.example` file in the folder, it will be copied into a `.env` file (to be used with the `dotenv` package for example).

#### `ddev playwright`

You can run all the playwright command with `ddev playwright [command]`.

- To run playwright's test command: 

  ```bash
  ddev playwright test
  ```

- To run with the UI.

  ```bash
  ddev playwright test --headed
  ```

- To generate playwright report

  ```bash
  ddev playwright show-report --host 0.0.0.0
  ```

  and then browse to `https://<PROJECT>.ddev.site:9323`

  ![show report](./docs/show-report.jpg)

### VNC server

When running in UI/headed mode, you can use the provided Kasmvnc service by browsing to `https://<PROJECT>.ddev.site:8444`

![kasmvnc](./docs/kasmvnc.jpg)

It could be also used to generate playwright code by browsing with the following command: 

```bash
ddev playwright codegen
```

### Other commands

As for any DDEV additional service, you can use the `ddev exec -s playwright [command]` snippet to run a command in the playwright container.

For example: 

- `ddev exec -s playwright yarn install --cwd ./var/www/html/yarn --force`
- `ddev exec -s playwright yarn --cwd /var/www/html/yarn test "__tests__/1-simple-test.js"`

## Technical notes

### arm64

On arm64 machine, edit the `playwright-build/Dockerfile` file to use `mcr.microsoft.com/playwright:focal-arm64` base image.



## Thanks

[devianintegral/ddev-playwright](https://github.com/deviantintegral/ddev-playwright) is another way of implementing Playwright as a DDEV add-on. The main difference is that this other add-on embeds Playwright in the Web container. Everyone can choose what suits them best.

We'd like to thank [devianintegral](https://github.com/deviantintegral) for the fruitful discussions we've had and the fact that we  are using a few pieces of code taken directly from his repository.

## Contribute

Anyone is welcome to submit a PR to this repo.

**Contributed and maintained by [julienloizelet](https://github.com/julienloizelet)**

