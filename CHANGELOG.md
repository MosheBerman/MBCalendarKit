# Changelog

## [unreleased]
...

## [5.2.0] 2019-04-18
### Added
- Added .travis.yml to augment Carthage support.


## [5.1.0] 2017-09-11
### Added 
- Added a demo for first day of the week handling.
- Added a demo for animated week transitions.

### Changed
- Fixes for `firstWeekday` bug. (#73, #110, #127)
- Fix infinite loop in `CKCalendarViewController`'s delegate implementation.
- If we try to set the view model's `date` to the same exact date that it already is, we return. This avoids firing off an entire layout pass.
- `CKCalendarCell` now takes an integer for `setNumber` instead of an `NSNumber`. This method uses a `asprintf` to format the string. This can be faster in some cases.
- Use `[NSLayoutConstraint activateConstraints:]` instead of `[self addConstraints:]` in `CKCalendarHeaderView`. The docs say that `activateConstraints:` is more efficient.
- Use the ivar for getting the cell identifier inside `CKGridView` instead of the property accessor.
- Compute the `initialOffset` once in the calendar model and cache it on the flow layout subclass, to avoid duplicating this computation per cell. 
- `CKCalendarView` now checks for `self.window` before reloading.
- Calling `setDate:` on `CKCalendarModel` passing a date that is the same day as the current date will short circuit after clamping to minimum/maximum dates, and the delegate methods will not get called.
- No longer call `reload` in `CKCalendarView`'s init. We call it later in the object's lifecycle anyway.
- Removed calls to `super` in `touchesBegan:`, `touchesMoved:` and friends. Much faster! 
- Cache `firstVisibleDate` and `lastVisibleDate`
- Cache the font used in the `CKCalendarCell` class.
- Cache `CKCalendarModel`'s `dateForIndexPath` and `indexPathForDate` values.
- Cache drawn polygon images in the next/back buttons.

## [5.0.5] 2017-10-02
### Changed
- Upgraded to Swift 4
- Update project settings to Xcode 9's defaults.

## [5.0.4] 2017-09-05
### Added
- Added an in-memory cache for date formatters.

### Changed
- Performance gains of about 60-75% when scrubbing 
- Audited `CKCalendarCell` for performance, including aggressive checking for changes before assigning new states, and reduced number of styling passes.
- Cache a string representation of the custom cell reuse identifier when we change the cell class instead of computing it at each call to `dequeue...`

### Removed
- Removed UIView(Borders), UIColor(HexString) and NSString(ToColor) categories for colors and borders.


## [5.0.3] 2017-08-21
- Made some more adjustments to Xcode schemes for tests.
- Reformatted changelog to match keepachangelog.com


## [5.0.2] 2017-08-18
- Corrected test target configuration so test target knows about the host app.


## [5.0.1] 2017-08-18
- Minor updates to readme.


## [5.0.0] 2017-08-17
### Added
- Code level documentation.
- Dynamic framework Support.
- Flag for animating week view properties.
- Support for custom cells with a new API.
- Adopted Autolayout.
- Adopted UICollectionView to render the calendar.
- Rendering in Interface Builder as an IBDesignable.
- Support for localization, including RTL environments. 
- Migration guide for MBCalendarKit 5.

### Changed
- Archived historical files that were cluttering the file system.
- Improved Swift interoperability with nullability and `NS_SWIFT_NAME()`.
- Reorganized files on disk and project structure to match.
- Updated changelog history going back to version 1.
- Updated sample app to showcase features of the framework.


## [4.0.1] 2017-08-01
### Changed
- Convert demo to Swift 3.

## [4.0.0] 2015-11-27
### Changed
- Migrated demo to Swift 2
- Cleaned up project 

### Removed
- Dropped support for iOS 7.

## [3.0.4] 2015-01-31
### Changed
- Clarified Swift code

## [3.0.3] 2015-01-30
### Fixed
- Fix deprecation warnings

## [3.0.2] 2015-01-12
### Added
- Added a promo image to the readme

### Fixed
- Bug fix for iPhone 6 and iPhone 6s

## [3.0.1] 2015-01-09
### Added
- Added a Swift sample to the demo app. 

## [3.0.0] 2015-01-09
### Changed
- Upgrade minimum version to iOS 7.

## [2.2.7] 2014-12-09
### Fixed
- Improve iPhone 6 and iPhone 6 Plus support and prepare for iPad.

## [2.2.6] 2014-11-29
### Fixed
- Fix a bug where events would not show in the table until the user interacts with the calendar. (#23, #57)

## [2.2.5] 2014-11-28
### Changed
- Improved documentation.
- Improved sample code.

## [2.2.4] 2014-11-28
### Added
- Added extensive detail to the documentation in the Readme.

## [2.2.3] 2014-08-09
### Changed
- Updated Readme

## [2.2.2] 2014-08-06
### Fixed
- Fixed issues related to date comparisons
- Fixed an issue where the next button was broken when January 31 was selected

## [2.2.1] 2014-08-06
### Fixed
- Updated readme and podspec

## [2.2.0] 2014-08-06
### Added
- Added support for `NSCalendar`'s `firstWeekday` property.

## [2.1.0] 2014-06-09
### Added
- Added ability to tag events with a color.

## [2.0.0] 2014-04-24
### Added
- Added support for LLVM’s modules feature. 

## [1.1.1] 2014-02-12
### Changed
- Some cleanup and clarifications in the readme.

## [1.1.0] 2013-09-13
### Changed
- Bug fixes

## [1.0.1] 2013-08-25
### Added
- Added a license file to the repo.

## [1.0.0] 2013-08-25
### Added
Initial release.

[unreleased]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.4...HEAD
[5.1.0]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.4...5.1.0
[5.0.4]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.3...5.0.4
[5.0.3]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.2...5.0.3
[5.0.2]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.1...5.0.2
[5.0.1]: https://github.com/mosheberman/MBCalendarKit/compare/5.0.0...5.0.1
[5.0.0]: https://github.com/mosheberman/MBCalendarKit/compare/4.0.1...5.0.0
[4.0.1]: https://github.com/mosheberman/MBCalendarKit/compare/4.0.0...4.0.1
[4.0.0]: https://github.com/mosheberman/MBCalendarKit/compare/3.0.4...4.0.0
[3.0.4]: https://github.com/mosheberman/MBCalendarKit/compare/3.0.3...3.0.4
[3.0.3]: https://github.com/mosheberman/MBCalendarKit/compare/3.0.2...3.0.3
[3.0.2]: https://github.com/mosheberman/MBCalendarKit/compare/3.0.1...3.0.2
[3.0.1]: https://github.com/mosheberman/MBCalendarKit/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.7...3.0.0
[2.2.7]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.6...2.2.7
[2.2.6]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.5...2.2.6
[2.2.5]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.4...2.2.5
[2.2.4]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.3...2.2.4
[2.2.3]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.2...2.2.3
[2.2.2]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.1...2.2.2
[2.2.1]: https://github.com/mosheberman/MBCalendarKit/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/mosheberman/MBCalendarKit/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/mosheberman/MBCalendarKit/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/mosheberman/MBCalendarKit/compare/1.1.1...2.0.0
[1.1.1]: https://github.com/mosheberman/MBCalendarKit/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/mosheberman/MBCalendarKit/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/mosheberman/MBCalendarKit/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/mosheberman/MBCalendarKit/compare/1.0.0...HEAD
