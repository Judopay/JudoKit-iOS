[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKit.svg)](http://travis-ci.org/JudoPay/JudoKit)

# judoKit Objective-C iOS SDK

This is the official judoKit iOS SDK written in Objective-C. It incorporates our mobile specific security toolkit, [judoShield](https://github.com/judopay/judoshield), with additional modules to enable easy native integration of payments. While the JudoKitObjC Framework has Swift annotations, we highly recommend using the original [judoKit](https://github.com/judopay/JudoKit) which is written in Swift.

##### **\*\*\*Due to industry-wide security updates, versions below 6.0 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

### What is this project for?

judoKit is a framework for integrating easy, fast and secure payments inside your app with [judo](https://www.judopay.com/). It contains an exhaustive in-app payments and security toolkit that makes integration simple and quick.

## ~~Integration~~

### Sign up to judo's platform

- To use judo's SDK, you'll need to [sign up](https://www.judopay.com/signup) and get your app token. 
- the SDK has to be integrated into your project using one of the following methods:

#### ~~CocoaPods~~

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

- You can install CocoaPods with the following command:

```bash
$ gem install cocoapods
```

- Add judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKitObjC', '~> 6.0'
```

- Then, run the following command:

```bash
$ pod install
```

- Please make sure to always **use the newly generated `.xcworkspace`** file not not the projects `.xcodeproj` file

#### ~~Carthage~~

[Carthage](https://github.com/Carthage/Carthage) - decentralized dependency management.

- You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

- To integrate judo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JudoPay/JudoKitObjC" >= 6.0
```

- Execute the following command in your project folder. This should clone the project and build the judoKit scheme:

```bash
$ carthage bootstrap
```

- On your application targets’ 'General' settings tab, in the 'Embedded Binaries' section, drag and drop `JudoKit.framework` from the Carthage/Build folder and `JudoShield.framework` from the Carthage/Checkouts folder on disk.
- On your application targets’ 'Build Phases' settings tab, click the '+' icon and choose 'New Run Script Phase'. Create a Run Script with the following contents:

```sh
/usr/local/bin/carthage copy-frameworks
```

- Then add the paths to the frameworks you want to use under 'Input Files', e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/JudoKit.framework
$(SRCROOT)/Carthage/Checkouts/JudoShield/Framework/JudoShield.framework
```

### ~~Manual integration~~

You can integrate judo into your project manually if you prefer not to use dependency management.

#### Adding the Framework

- Add judoKit as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, changing into your project directory, and entering the following command:

```bash
$ git submodule add https://github.com/JudoPay/JudoKitObjC
```

- As judoKit has submodules, you need to initialize them as well by cd-ing into the `JudoKitObjC` folder and executing the following command:

```bash
$ cd JudoKitObjC
$ git submodule update --init --recursive
```
- Open your project and select your application in the Project Navigator (blue project icon).
- Drag and drop the `JudoKitObjC.xcodeproj` project file inside the judoKit folder into your project (just below the blue project icon inside Xcode).
- Navigate to the target configuration window and select the application target under the 'Targets' heading in the sidebar.
- In the tab bar at the top of that window, open the 'General' panel.
- Click on the '+' button in 'Embedded Binaries' section.
- Click on 'Add Other...' and navigate to the `JudoKit/JudoShield/Framework` Folder and add `JudoShield.framework`.
- Click on the same '+' button and add `JudoKitObjC.framework` under the judoKit project from the `Products` folder.
- In the project navigator, click on the '+' button under the 'Linked Frameworks and Libraries' section.
- Select `Security.framework`, `CoreTelephony.framework` and `CoreLocation.framework` from the list presented.
- Open the 'Build Settings' panel.
- Search for `Framework Search Paths` and add `$(PROJECT_DIR)/JudoKit/JudoShield/Framework`.
- Search for `Runpath Search Paths` and make sure it contains `@executable_path/Frameworks`.

### Further setup

- Add `#import "JudoKitObjC.h"` to the top of the file where you want to use the SDK.

- You can set your key and secret here when initializing the Session:

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

#### Make a simple Payment

```obj
  // TODO:
```

#### Make a simple Pre-authorization

```obj
  // TODO:
```


#### Register a card

```obj
  // TODO:
```

#### Make a repeat Payment

```obj
  // TODO:
```

#### Make a repeat Pre-authorization

```obj
  // TODO:
```

## Card acceptance configuration

judoKit is capable of detecting and accepting a huge array of Card Networks. An array of Card Networks defines a specific acceptance signature. This is used as shown below.

The default value for accepted Card Networks are Visa and MasterCard:

```obj
_acceptedCardNetworks = @[@(CardNetworkVisa), @(CardNetworkMasterCard)];
```

In case you want to add the capability of accepting AMEX you need to add the following:

```objc
self.judoKitSession.theme.acceptedCardNetworks = @[@(CardNetworkVisa), @(CardNetworkMasterCard)];
```

Any other card configuration that is available can be added for the UI to accept the specific Card Networks. **BE AWARE** you do need to configure your account with judo for any other Card Networks transactions to be processed successfully.

## Customizing payments page theme

![lighttheme1](http://judopay.github.io/JudoKit/ressources/lighttheme1.png "Light Theme Example Image")
![lighttheme2](http://judopay.github.io/JudoKit/ressources/lighttheme2.png "Light Theme Example Image")
![darktheme1](http://judopay.github.io/JudoKit/ressources/darktheme2.png "Dark Theme Example Image")

judoKit comes with our new customizable, stacked UI.

### Theme class

The following parameters can be accessed through `JudoKit.theme`.

#### Colors

```objc
- (nonnull UIColor *)judoDarkGrayColor;
- (nonnull UIColor *)judoInputFieldTextColor;
- (nonnull UIColor *)judoLightGrayColor;
- (nonnull UIColor *)judoInputFieldBorderColor;
- (nonnull UIColor *)judoContentViewBackgroundColor;
- (nonnull UIColor *)judoButtonColor;
- (nonnull UIColor *)judoButtonTitleColor;
- (nonnull UIColor *)judoLoadingBackgroundColor;
- (nonnull UIColor *)judoRedColor;
- (nonnull UIColor *)judoLoadingBlockViewColor;
- (nonnull UIColor *)judoInputFieldBackgroundColor;
```

#### General settings

```objc
/**
 *  An array of accepted card networks
 */
@property (nonatomic, strong) NSArray<NSNumber *> * _Nonnull acceptedCardNetworks;

/**
 *  A tint color that is used to generate a theme for the judo payment form
 */
@property (nonatomic, strong) UIColor * _Nonnull tintColor;

/**
 *  Set the address verification service to true to prompt the user to input his country and post code information
 */
@property (nonatomic, assign) BOOL avsEnabled;

/**
 *  A boolean indicating whether a security message should be shown below the input
 */
@property (nonatomic, assign) BOOL showSecurityMessage;
```

#### Button titles

```objc
/**
 *  The title for the payment button
 */
@property (nonatomic, strong) NSString * _Nonnull paymentButtonTitle;

/**
 *  The title for the button when registering a card
 */
@property (nonatomic, strong) NSString * _Nonnull registerCardButtonTitle;

/**
 *  The title for the back button of the navigation controller
 */
@property (nonatomic, strong) NSString * _Nonnull registerCardNavBarButtonTitle;

/**
 *  The title for the back button
 */
@property (nonatomic, strong) NSString * _Nonnull backButtonTitle;
```

#### Page titles

```objc
/**
 *  The title for a payment
 */
@property (nonatomic, strong) NSString * _Nonnull paymentTitle;

/**
 *  The title for a card registration
 */
@property (nonatomic, strong) NSString * _Nonnull registerCardTitle;

/**
 *  The title for a refund
 */
@property (nonatomic, strong) NSString * _Nonnull refundTitle;

/**
 *  The title for an authentication
 */
@property (nonatomic, strong) NSString * _Nonnull authenticationTitle;
```

#### Loading block titles

```objc
/**
 *  When a register card transaction is currently running
 */
@property (nonatomic, strong) NSString * _Nonnull loadingIndicatorRegisterCardTitle;

/**
 *  The title of the loading indicator during a transaction
 */
@property (nonatomic, strong) NSString * _Nonnull loadingIndicatorProcessingTitle;

/**
 *  The title of the loading indicator during a redirect to a 3DS webview
 */
@property (nonatomic, strong) NSString * _Nonnull redirecting3DSTitle;

/**
 *  The title of the loading indicator during the verification of the transaction
 */
@property (nonatomic, strong) NSString * _Nonnull verifying3DSPaymentTitle;

/**
 *  The title of the loading indicator during the verification of the card registration
 */
@property (nonatomic, strong) NSString * _Nonnull verifying3DSRegisterCardTitle;

```

#### Input field parameters

```objc
/**
 *  The height of the input fields
 */
@property (nonatomic, assign) CGFloat inputFieldHeight;
```

#### Security message

```objc
/**
 *  The message that is shown below the input fields the ensure safety when entering card information
 */
@property (nonatomic, strong) NSString * _Nonnull securityMessageString;

/**
 *  The text size of the security message
 */
@property (nonatomic, assign) CGFloat securityMessageTextSize;
```

