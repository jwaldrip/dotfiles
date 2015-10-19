# Travis CI Status [![Build Status](https://travis-ci.org/tombell/travis-ci-status.svg?branch=master)](https://travis-ci.org/tombell/travis-ci-status)

Add Travis CI status of the project to the Atom status bar.

![Atom Status Bar Screenshot](https://raw.githubusercontent.com/tombell/travis-ci-status/master/travis_ci_status.png)

## Installing

Use the Atom package manager, which can be found in the Settings view or run
`apm install travis-ci-status` from the command line.

## Usage

The Travis CI build status for your repository will be indicated by the
clock-arrow icon in the status bar. The icon will appear orange when it's
requesting the build status, green if the build was successful and red if the
build failed.

The build status is updated when the project is first opened in Atom and from
then on whenever the "status" of the project repository changes. The handling of
these events was borrowed from the `git-view.coffee` part of the `status-bar`
package.

### Remote Name

If the remote repository Travis is configured to build is named something other
than `origin`, you can specify a different name in the **Travis Ci Remote Name**
field in the settings view.

### Travis Pro

You are able to use this with Travis Pro if you enable it in the settings view.
You will also need to generate and set a
[GitHub API token](https://github.com/settings/tokens/new) to be able to
authenticate with the Travis Pro API.

### Commands

The following commands are available for users to keymap.

* `travis-ci-status:toggle` - Toggle the status bar entry
* `travis-ci-status:toggle-build-matrix` - Toggle the build matrix panel
* `travis-ci-status:open-on-travis` - Open the project on the Travis CI site

## Coming Soon

Feel free to open an issue to discuss potential features to add or improve.
