fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### fetch_and_increment_build_number

```sh
[bundle exec] fastlane fetch_and_increment_build_number
```

Bump build number based on most recent TestFlight build number

### prepare_signing

```sh
[bundle exec] fastlane prepare_signing
```

Check certs and profiles

### build_release

```sh
[bundle exec] fastlane build_release
```

Build the iOS app for release

### upload_release

```sh
[bundle exec] fastlane upload_release
```

Upload to TestFlight / ASC

### build_upload_testflight

```sh
[bundle exec] fastlane build_upload_testflight
```

Build and upload to TestFlight

----


## iOS

### ios load_asc_api_key

```sh
[bundle exec] fastlane ios load_asc_api_key
```

Load ASC API Key information to use in subsequent lanes

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
