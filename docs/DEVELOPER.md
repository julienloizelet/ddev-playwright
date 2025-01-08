# ddev-playwright add-on

## Developer guide

**Table of Contents**

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Commit message](#commit-message)
  - [Allowed message `type` values](#allowed-message-type-values)
  - [Squash and merge pull request](#squash-and-merge-pull-request)
- [Update documentation table of contents](#update-documentation-table-of-contents)
- [Release process](#release-process)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Commit message

This is not formally required, but in order to have an explicit commit history, we use some commits message convention with the following format:

    <type>(<scope>): <subject>

Allowed `type` are defined below.
`scope` value intends to clarify which part of the code has been modified. It can be empty or `*` if the change is a
global or difficult to assign to a specific part.
`subject` describes what has been done using the imperative, present tense.

Example:

    feat(logger): Add a new property for logger

### Allowed message `type` values

- chore (automatic tasks; no production code change)
- ci (updating continuous integration process; no production code change)
- comment (commenting;no production code change)
- docs (changes to the documentation)
- feat (new feature for the user)
- fix (bug fix for the user)
- refactor (refactoring production code)
- style (formatting; no production code change)
- test (adding missing tests, refactoring tests; no production code change)

### Squash and merge pull request

Please note that if you merge a pull request in GitHub using the "squash and merge" option (recommended), the pull request title will be used as the commit message for the squashed commit.

You should ensure that the resulting commit message is valid with respect to the above convention.

## Update documentation table of contents

To update the table of contents in the documentation, you can use [the `doctoc` tool](https://github.com/thlorenz/doctoc).

First, install it:

```bash
npm install -g doctoc
```

Then, run it in the root folder:

```bash
doctoc README.md --maxlevel 4 && doctoc docs/* --maxlevel 4
```

## Release process

We are using [semantic versioning](https://semver.org/) to determine a version number.

Before publishing a new release, there are some manual steps to take:

- Update the `CHANGELOG.md` file to the current format. The release description is based on the contents of the `CHANGELOG.md` file.

Then, you have to [run the action manually from the GitHub repository](https://github.com/ddev/github-action-add-on-test/actions/workflows/release.yml)

Alternatively, you could use the [GitHub CLI](https://github.com/cli/cli):

- publish a release:

```
gh workflow run release.yml -f tag_name=vx.y.z
```

Note that the GitHub action will fail if the tag `tag_name` already exits.
