# DynamicStatistics

[![CI Status](http://img.shields.io/travis/492334421@qq.com/DynamicStatistics.svg?style=flat)](https://travis-ci.org/492334421@qq.com/DynamicStatistics)
[![Version](https://img.shields.io/cocoapods/v/DynamicStatistics.svg?style=flat)](http://cocoapods.org/pods/DynamicStatistics)
[![License](https://img.shields.io/cocoapods/l/DynamicStatistics.svg?style=flat)](http://cocoapods.org/pods/DynamicStatistics)
[![Platform](https://img.shields.io/cocoapods/p/DynamicStatistics.svg?style=flat)](http://cocoapods.org/pods/DynamicStatistics)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DynamicStatistics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DynamicStatistics_OC'
```

## What is it?
It is a simple library helps to collect user action dynamically.

## How to use?
Setup config file with local plist file or from network. 

### With local plist file:

```objc
[[DynamicStatistics sharedInstance] setupWithPlist:@"DynamicStatistics" andEventLogBlock:^(DSViewEvent *event) {
//todo: log the event with your service or any other analytic platform, like Flurry.
}];
```
### From network:
```objc
[[DynamicStatistics sharedInstance] setupWithUrlString:@"http://xxx.com/version=1.0" andEventLogBlock:^(DSViewEvent *event) {
//todo: log the event with your service or any other analytic platform, like Flurry.
}];
```

### Log all events or page events

There are two mothods helps you to log more events.

```objc
[[DynamicStatistics sharedInstance] setLogAllEvent:YES];
```

```objc
[[DynamicStatistics sharedInstance] setLogAllPageEvent:YES];
```

## Plist file format
The local plist file format and text result from network should keep the same format. 
`viewPath` is the key to identify the view. You can get it when testing from console. It is like a simplified XPath, but with index in the end. You can set index as `*` to represent any position. `eventName` is a readable name to describe the `viewPath`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
   "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <array>
        <dict>
            <key>viewPath</key>
            <string>DSViewController-UIAlertAction_OK&amp;&amp;0-0</string>
            <key>eventName</key>
            <string>AlertVC-OK</string>
        </dict>
        <dict>
            <key>viewPath</key>
            <string>DSViewController-UIAlertAction_Cancel&amp;&amp;0-0</string>
            <key>eventName</key>
            <string>AlertVC-Cancel</string>
        </dict>
        <dict>
            <key>viewPath</key>
            <string>DSViewController-UIView-UITableView-UITableViewWrapperView-UITableViewCell&amp;&amp;0-0-1-0-*:*</string>
            <key>eventName</key>
            <string>HomePage-TableCell</string>
        </dict>
        <dict>
            <key>viewPath</key>
            <string>DSViewController-UIView-UIButton&amp;&amp;0-0-5</string>
            <key>eventName</key>
            <string>ShowAlertController</string>
        </dict>
        <dict>
            <key>viewPath</key>
            <string>DSViewController&amp;&amp;*</string>
            <key>eventName</key>
            <string>Homepage</string>
        </dict>
    </array>
</plist>
```

## Author

David.Li, David.Li@activenetwork.com

## License

DynamicStatistics is available under the MIT license. See the LICENSE file for more info.
