# WaniKit

[![Build Status](https://travis-ci.org/haawa799/WaniKit.svg?branch=master)](https://travis-ci.org/haawa799/WaniKit)
[![Version](https://img.shields.io/cocoapods/v/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)
[![License](https://img.shields.io/cocoapods/l/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)
[![Platform](https://img.shields.io/cocoapods/p/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)

![alt text](http://cl.ly/372F1I0C252D/Icon@2x.png"Logo")
####WaniKit - Swift wrapper for WaniKani.com API. It's based on `NSOperation` and `NSOperationQueue`, as described in [this WWDC2015 talk](https://developer.apple.com/videos/play/wwdc2015-226/).

####I built it mainly for my - [iOS WaniKani client](https://github.com/haawa799/WaniKani-iOS).


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

1. Create manger object, and provide it with WaniKani API key (can be found in Settings of your WaniKani profile)

	```swift
	let manager = WaniApiManager()
    manager.setApiKey("0123abc0123abc0123abc") // Pass key here
    ```

2. Fetch Study queue data

	```swift
	manager.fetchStudyQueue({ (userInfo, studyQInfo) -> Void in
      print("userInfo: \(userInfo)")
      print("studyQInfo: \(studyQInfo)")
    })
	```

3. Fetch Level progression

	```swift
	manager.fetchLevelProgression({ (userInfo, levelProgression) -> Void in
      print("userInfo: \(userInfo)")
      print("levelProgression: \(levelProgression)")
    })
	```

4. If for any reason you need only user info

	```swift
	manager.fetchUserInfo { (userInfo) -> Void in
      print("userInfo: \(userInfo)")
    }
	```

5. More calls to come!

##

## Important note

Manager operates using serial queue, therefore requests will be executed in order in which you are calling them, and no one will start untill one before it will finish.

Also there can only be one operation of each kind in the queue, therefore if you for example call `fetchStudyQueue` three times it will execute it only once.

If you need multimple same requests sent at the same time, you can use two managers or open an issue here on Github.


## Installation

### Cocoapods
WaniKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WaniKit"
```

### Carthage
WaniKit is avaliable through Carthage. To install

1. In Cartfile add: 
```ruby
github "haawa799/WaniKit"
```

2. Build framework for different platforms with:
```shell
carthage update --platform iOS
```
or
```shell
carthage update --platform Mac
```

3. Manually add framework to your targets

## Author

Andriy Kharchyshyn., haawaplus@gmail.com
######@haawa799
######Go say hi at linked in https://ua.linkedin.com/in/andrew-kharchyshyn-39639164

## License

WaniKit is available under the MIT license. See the LICENSE file for more info.
