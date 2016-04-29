# judoKit Objective-C iOS SDK change log
All notable changes to this project will be documented in this file.
'judoKit' adheres to [Semantic Versioning](http://semver.org/).

- `6.0.x` Releases - [6.0.0](#600) | [6.0.1](#601) | [6.0.2](#602)
- `5.x` Releases and below are related to the [judo-ObjC SDK](https://github.com/JudoPay/Judo-ObjC)


## [6.0.2](https://github.com/JudoPay/JudoKitObjC/releases/tag/6.0.2)
TBA

#### Added
- UI Test for Maestro token payment.

#### Changed
- Injected card information is now shown with masking the card number.

#### Fixed
- An issue where deleting the slash in a date input field would result in unexpected behavior.
- An issue where the sdk would assume a token payment when card details were be injected (eg. by card scanning).
- An issue where injected card info would not appear correctly.

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
