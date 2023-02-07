[![tests](https://github.com/julienloizelet/ddev-playwright/actions/workflows/tests.yml/badge.svg)](https://github.com/julienloizelet/ddev-playwright/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2023.svg)

# ddev-playwright

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Introduction](#introduction)
- [Installation](#installation)
- [Basic usage](#basic-usage)
  - [Yarn install](#yarn-install)
  - [Launch Playwright test](#launch-playwright-test)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

[Playwright](https://playwright.dev) was created to accommodate the needs of end-to-end testing. 

This DDEV add-on allows you to use Playwright in a separate `playwright` service.


## Installation

`ddev get julienloizelet/ddev-playwright && ddev restart`

## Basic usage

You can run all the basic `yarn` commands in the `playwright` container. 

As an example, you will find some testing and configuration files in the `tests/testdata/yarn` folder of this project.

### Yarn install

`ddev exec -s playwright yarn install --cwd ./var/www/html/yarn --force`

### Launch Playwright test 

`ddev exec -s playwright yarn --cwd /var/www/html/yarn test "__tests__/1-simple-test.js"`


## Contribute

Anyone is welcome to submit a PR to this repo.


**Contributed and maintained by [julienloizelet](https://github.com/julienloizelet)**

