# CMPlayerViewController





[![CI Status](http://img.shields.io/travis/Célian Moutafis/CMPlayerViewController.svg?style=flat)](https://travis-ci.org/Célian Moutafis/CMPlayerViewController)
[![Version](https://img.shields.io/cocoapods/v/CMPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/CMPlayerViewController)
[![License](https://img.shields.io/cocoapods/l/CMPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/CMPlayerViewController)
[![Platform](https://img.shields.io/cocoapods/p/CMPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/CMPlayerViewController)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

<img src="./Assets/SC2.png" alt="sample" title="Sample" width="480" height="268"/>

CMPlayerViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CMPlayerViewController"
```

## Usage ##

To instanciate the ViewController


```swift
	let playerViewController = CMPlayerViewController(url : "myVideoUrl")
	self.presentViewController(playerViewController, animated: true, completion: nil)
```

## Author

Célian Moutafis

## License

CMPlayerViewController is available under the Apache license. See the LICENSE file for more info.
