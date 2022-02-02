# Shortcut Foundation

Contains common utility functions and extensions.

![Swift 5.5](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Platforms](https://img.shields.io/badge/Xcode-12-orange.svg?style=flat)
![Platforms](https://img.shields.io/badge/platform-iOS-orange.svg?style=flat)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange.svg)](https://github.com/apple/swift-package-manager)

## Features

- [x] List features here

## Requirements

- **iOS 12+**
- **Xcode 11+**
- **Jazzy** ```[sudo] gem install jazzy```
- **Brew** ```/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```
- **Make** ```brew install make```
- **Swiftlint** ```brew install swiftlint```

## Style Guide

Following our style guide should:

* Make it easier to read and begin understanding the unfamiliar code.
* Make code easier to maintain.
* Reduce simple programmer errors.
* Reduce cognitive load while coding.
* Keep discussions on diffs focused on the code's logic rather than its style.

*Note that brevity is not a primary goal.*

[Official Style Guide](https://github.com/shortcut/shortcut-style-guide-ios)

## Installation

####Using as a dependency

``` swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "YourTestProject",
  dependencies: [
    .package(url: "git@github.com:shortcut/shortcut-foundation-ios.git", from: "0.0.7")
  ],
  targets: [
    .target(name: "YourTestProject", dependencies: ["ShortcutFoundation"])
  ]
)
```
And then import wherever needed: ```import ShortcutFoundation ```

#### Adding it to an existent iOS Project via Swift Package Manager

1. Using Xcode 11 or greater go to File > Swift Packages > Add Package Dependency
2. Paste the project URL: `git@github.com:shortcut/shortcut-foundation-ios.git`
3. Click on next and select the project target

If you have doubts, please, check the following links:

[How to use](https://developer.apple.com/videos/play/wwdc2019/408/)

[Creating Swift Packages](https://developer.apple.com/videos/play/wwdc2019/410/)

After successfully retrieved the package and added it to your project, just import `ShortcutFoundation` and you can get the full benefits of it.


## Usage example

```swift
import ShortcutFoundation

...
```

## Contributing to the library

1. Clone the repository
2. Create your feature branch
3. Open the `Package.swift` file
4. Perform your changes, debug, run the unit tests
5. Make sure that all the tests pass and there are no Xcode warnings or lint issues
6. Open a pull request

We have added a few helpers to make your life easier:

1. ```make build``` to build the project via command line
2. ```make test``` to test the project via command line
3. ```make jazzy``` to generate the documentation and output to the `Docs` folder
4. ```make lint``` to execute Swiftlint
5. ```make fixlint``` to auto-correct Swiftlint warnings
