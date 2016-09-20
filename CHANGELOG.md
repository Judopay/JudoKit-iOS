# judoKit Objective-C iOS SDK change log
All notable changes to this project will be documented in this file.
'judoKit' adheres to [Semantic Versioning](http://semver.org/).

- `6.2.x` Releases - [6.2.1](#621)
- `6.1.x` Releases - [6.1.0](#610)
- `6.0.x` Releases - [6.0.0](#600) | [6.0.1](#601) | [6.0.2](#602)
- `5.x` Releases and below are related to the [judo-ObjC SDK](https://github.com/JudoPay/Judo-ObjC)

## [6.2.3](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.2.3)
Released on 2016-09-20

#### Added
- Latest version of JudoShield

## [6.2.2](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.2.2)
Released on 2016-09-14

#### Added
- Latest version of JudoShield
- Minor bug fixes.

## [6.2.1](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.2.1)
Released on 2016-06-29

#### Added
- Added a navigation bar title color to the Theme object.
- SDK now detects if device is jailbroken.

## [6.1.0](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.1.0)
Released on 2016-06-02

#### Changed
- Injected card details are not masked and can be changed by the user
- Transaction gets created at initialization to enable adding and removing of custom information.
- Statically accessible version number instead of polling for bundle due to an issue with CocoaPods.

---

## [6.0.2](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.0.2)
Released on 2016-05-06

#### Added
- UI Test for Maestro token payment.
- A feature to initiate input into card and security card textfields with the Apple keyboard instead of 3rd party keyboard providers to ensure user security.
- UI and Integration tests for dedup.

#### Changed
- Injected card information is now shown with masking the card number.
- Camel case for 'ID'.

#### Removed
- Unused code
- TODO flags

#### Fixed
- An issue where deleting the slash in a date input field would result in unexpected behavior.
- An issue where the sdk would assume a token payment when card details were be injected (eg. by card scanning).
- An issue where injected card info would not appear correctly.
- An issue where the wrong error was returned for multiple payments with identical payment reference.
- Some issues with the UI and integration tests around deduplication.

---

## [6.0.1](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.0.1)
Released on 2016-04-28

#### Added
- Added a method that recursively searches for the currently active and visible ViewController.

#### Changed
- The deviceDNA will now be attached to the HTTP Request Body of any Transaction.

---

## [6.0.0](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.0.0)
Released on 2016-04-20

#### Added
- Initial release
	- Added by [Hamon Ben Riazy](https://github.com/ryce).
