[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JudoKitObjC.svg)](https://img.shields.io/cocoapods/v/JudoKitObjC.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKitObjC.svg)](http://http://cocoadocs.org/docsets/JudoKitObjC)
[![Platform](https://img.shields.io/cocoapods/p/JudoKitObjC.svg)](http://http://cocoadocs.org/docsets/JudoKitObjC)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKitObjC.svg)](http://travis-ci.org/JudoPay/JudoKitObjC)

# judoKit Objective-C iOS SDK

This is the official judoKit iOS SDK written in Objective-C. It incorporates our mobile specific security toolkit, [judoShield](https://github.com/judopay/judoshield), with additional modules to enable easy native integration of payments. If you are integrating your app in swift, we highly recommend using the original [judoKit](https://github.com/judopay/JudoKit).

Use our UI components for a seamless user experience for card data capture. Minimise your [PCI scope](https://www.pcisecuritystandards.org/pci_security/completing_self_assessment) with a UI that can be themed or customised to match the look and feel of your app.

##### **\*\*\*Due to industry-wide security updates, versions below 6.0 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

### What is this project for?

judoKit is a framework for integrating easy, fast and secure payments in your app with [judo](https://www.judopay.com/). It contains an exhaustive in-app payments and security toolkit that makes integration simple and quick.


## Getting started

### Integrating CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

- You can install CocoaPods with the following command:

```bash
$ gem install cocoapods
```

- Add judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'JudoKitObjC', '~> 6.0'
```

- Then, run the following command:

```bash
$ pod install
```

- Please make sure to always **use the newly generated `.xcworkspace`** file not not the projects `.xcodeproj` file

### Initial setup

- Add `#import <JudoKitObjC/JudoKitObjC.h>` to the top of the file where you want to use the SDK.

- You can set your key and secret here when initializing the session:

```objc
// initialize the SDK by setting it up with a token and a secret
self.judoKitSession = [[JudoKit alloc] initWithToken:token secret:secret];
```

- To instruct the SDK to communicate with the Sandbox, include the following lines in the ViewController where the payment should be initiated:

```objc
// setting the SDK to Sandbox Mode - once this is set, the SDK wil stay in Sandbox mode until the process is killed
self.judoKitSession.apiSession.sandboxed = YES;
```

- When you are ready to go live you can remove this line.

### Invoking a payment screen

```objc
    JPAmount *amount = [[JPAmount alloc] initWithAmount:@"25.0" currency:@"GBP"];
    
    [self.judoKitSession invokePayment:judoID amount:amount consumerReference:@"consRef" cardDetails:nil completion:^(JPResponse * response, NSError * error) {
        if (error || response.items.count == 0) {
            if (error.domain == JudoErrorDomain && error.code == JudoErrorUserDidCancel) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
	            // handle error
            }
        } else {
        	// handle success
        }
    }];
```

## Next steps

JudoKit supports a range of customization options. For more information on using judo for iOS see our [wiki documentation](https://github.com/JudoPay/JudoKitObjC/wiki/).