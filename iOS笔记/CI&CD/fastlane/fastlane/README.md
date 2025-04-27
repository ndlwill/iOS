fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

=====Test a lane=====

### ios before_build

```sh
[bundle exec] fastlane ios before_build
```

=====before_build(不能单独使用)=====

### ios confirm_info

```sh
[bundle exec] fastlane ios confirm_info
```

=====Confirm Info(不能单独使用)=====

### ios ios_release

```sh
[bundle exec] fastlane ios ios_release
```

=====iOS Release(可单独使用)=====

### ios ios_appstore

```sh
[bundle exec] fastlane ios ios_appstore
```

=====To AppStore(可单独使用)=====

### ios build

```sh
[bundle exec] fastlane ios build
```

=====Build(不能单独使用)=====

### ios deliver_appstore

```sh
[bundle exec] fastlane ios deliver_appstore
```

=====Deliver AppStore(不能单独使用)=====

### ios match_generate_development

```sh
[bundle exec] fastlane ios match_generate_development
```

=====match_generate_development=====

### ios match_generate_appstore

```sh
[bundle exec] fastlane ios match_generate_appstore
```

=====match_generate_appstore=====

### ios match_fetch_development

```sh
[bundle exec] fastlane ios match_fetch_development
```

=====match_fetch_development=====

### ios match_fetch_appstore

```sh
[bundle exec] fastlane ios match_fetch_appstore
```

=====match_fetch_appstore=====

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
