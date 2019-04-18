![Promo](https://github.com/MosheBerman/MBCalendarKit/raw/master/Promo/Banner.png)

# About

MBCalendarKit is a calendar control written in Objective-C with modern best practices and Swift interoperability in mind. 

It offers a flexible calendar control, with support for displaying any calendar system supported by `NSCalendar`. It also includes an API to  customize the calendar cells. It also ships with a prebuilt view controller, inspired by the original iOS calendar. 

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.com/MosheBerman/MBCalendarKit.svg?branch=master)](https://travis-ci.com/MosheBerman/MBCalendarKit)

## Features
- Interactive Calendar Control
- Autolayout Support
- Dynamic Framework for iOS 8+
- Custom Cell API with Default Implementation
- Calendar Event Display
- Custom First Weekday
- Clamp Dates to Minimum and/or Maximum Values
- Display for Any Locale or Calendar Identifier
- Display Modes: Month, Week, and Day
- Localization Support, Including Right-to-Left and Date Formatting
- Pre-built View Controller inspired by the original iOS Calendar App
- Sample App With Various Demo Implementations


# Getting Started:

You'll need to target iOS 8+. There are ~three~ four ways to integrate MBCalendarKit:

1. Cocoapods: `pod 'MBCalendarKit', '~> 5.0.0'`
2. Carthage: `github MosheBerman/MBCalendarKit ~> 5.2.0`    
3. Drag this Xcode project in to your own, and add the framework as a dependency.
4. If you really want to drag the raw source in, the framework code is in `MBCalendarKit/CalendarKit`.

If there are any problems, please head over to issue #48 and leave a comment. 

## Swift & Objective-C
MBCalendarKit is written in Objective-C. To use MBCalendarKit with Swift, just link against and use `import MBCalendarKit`.  MBCalendarKit 5.0.0 includes a number of Swift enhancements. 

The examples here are in Swift, for berevity. Note that when writing Objective-C, MBCalendarKit prefixes its classes and enums with `CK`. `CalendarView` in Swift is `CKCalendarView` in Objective-C, etc. 

For specifics, check out the [Migration Guide](./MIGRATIONGUIDE.md).


# Features 
## Presenting a Calendar
You have two choices for showing a calendar using MBCalendarKit. 

1. You can show an instance of `CKCalendarView`. Use this if you want to manually manage your view hierarchy or just want a calendar view without the events table view.


```` swift

/// Here's how you'd show a CalendarView from within a view controller.
/// Import the framework, then it's just three easy steps.

import MBCalendarKit
    	
// 1. Instantiate a CKCalendarView
let calendar = CalendarView()
 		
// 2. Present the calendar 
self.view.addSubview(calendar)

// 3. Add positioning constraints:
self.calendarView.translatesAutoresizingMaskIntoConstraints = false
calendarView.topAnchor.constraint(equalTo:self.topLayoutGuide.bottomAnchor).isActive = true
calendarView.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true

````

2. Your second option is to create an instance of `CalendarViewController`. Using a CKCalendarViewController gives you the added benefit of a "today" button and a segmented control in the toolbar, which allows you to select the display mode. In MBCalendarKit 5.0.0 and later, you also use `CalendarViewController` if you'd like an events table view.


```` swift

/// Here's how you'd show a CalendarViewController from 
/// within a view controller. It's just three easy steps, including the framework import.
		
// 1. Import MBCalendarKit:
import MBCalendarKit
    	
// 2. Instantiate a CalendarViewController
let calendar = CalendarViewController()
 		
// 3. Present the calendar 
self.present(calendar animated:true completion:nil)
		
````

With both `CalenderView` and `CalendarViewController`, you can use the `dataSource` and `delegate` properties to display events, and get information about user interation.

---
***Note:*** In older versions of MBCalendarKit, `CKCalendarViewController` used to subclass `UINavigationViewController`, so it couldn't be installed inside of another navigation controller. In 5.0.0, this is no longer the case. If you wish to embed your calendar inside a `UINavigationViewController`, you must now install it on your own. See the [Migration Guide](./MIGRATIONGUIDE.md) for details.

---

In MBCalendarKit 5.0.0, there's a new property on `CalendarView` called `customCellProvider`, which can be used to customize the display of the cells in a really powerful way. Keep reading to learn more about setting up events


## Showing Events
The `CKCalendarDataSource` protocol defines a method, which supplies an array of `CKCalendarEvent` objects. The calendar view automatically shows an indicator in cells that represent dates that have events. 

```` swift
func calendarView(_ calendarView: CalendarView, eventsFor date: Date) -> [CalendarEvent]
````
In your data source, implement this method and return the events matching the date being passed in.

Here's an example of adding a few events to the calendar:

```` swift
func adEventsToCalendar() {
  let title : NSString = NSLocalizedString("Add Swift Demo", comment: "") as NSString
    if let date : Date = NSDate(day: 9, month: 1, year: 2015) as Date?
    {
      let event : CalendarEvent = CalendarEvent(title: title as String, andDate: date, andInfo: nil)
      self.data[date] = [event]
    } 

    let title2 : NSString = NSLocalizedString("Release MBCalendarKit 5.0.0", comment: "") as NSString
    if let date2 : Date = NSDate(day: 15, month: 8, year: 2017) as Date?
    {
      let event2 : CalendarEvent = CalendarEvent(title: title2 as String, andDate: date2, andInfo: nil)
      self.data[date2] = [event2]
    }
}
````

Now, implement the data source:
    
````swift
//  MARK: - CalendarDataSource

override func calendarView(_ calendarView: CalendarView, eventsFor date: Date) -> [CalendarEvent] 
{
    let eventsForDate = self.data[date] ?? []
 
    return eventsForDate
}
````

**Note:** The dates used as keys must match the dates passed into the data source method exactly. One way to ensure this is to use the `NSCalendar`'s `isDate:equalToDate:toUnitGranularity:`, passing in the two dates and `.day` as the third argument, to create the dates you pass to your events.

You can also see this code in `CKDemoViewController.m` or `SwiftDemoViewController.swift` in the demo app.
		
## Handling User Interaction
These methods, defined in the `CalendarViewDelegate` protocol, are called on the delegate when the used selects a date. A date is considered selected when either an arrow in the header is tapped, or when the user lifts their finger from a cell.

```` swift
func calendarView(_ calendarView: CalendarView, willSelect date: Date) 
func calendarView(_ calendarView: CalendarView, didSelect date: Date) 
````  

This method is called on the delegate when a row is selected in the events table. You can use to push a detail view, for example.

```` swift
func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) 
````   

## Customizing Cells 
MBCalendarKit 5.0.0 brings a brand new way to customize cells, so that you can add your own data to the cells, or even do a completely design. By building on top of `UICollectionView`, MBCalendarKit provides a really simple API. First, you need to implement `CustomCellProviding` in your code. This is composed of two parts: First, telling MBCalendarKit which `UICollectionViewCell` subclass to use for the cells, and second, implementing a method callback which will be your opportunity to customize the cell based on its context.

Let's look at an implementation based on the default implementation:

```` Swift

// Step 1. Formally adopt the `CustomCellProviding` protocol
Class MyCustomCellProvider: NSObject, CustomCellProviding {

    // Step 2. Inform the framework of your `UICollectionViewCell` subclass, so it knows to use it.
    var customCellClass: AnyClass
    {
        return CKCalendarCell.self
    }

    // Step 3. Implement the custom cell delegate callback
    func calendarView(_ calendarView: CalendarView, willDisplay cell: UICollectionViewCell, in context: CalendarCellContext) {

        // It's reasonable to cast to whatever class is in `customCellClass`.
        guard let cell = cell as? CustomCalendarCell else
        {
            return
        }

        // Customize the cell's contents and display here.
    }
}
````

Now, simply tell the calendar view that your object is providing custom cells:

```` swift
// 0. Assume an existing calendarView

// 1. Instantiate your custom cell provider.
let myCustomCellProvider = MyCustomCellProviderClass()

// 2. Assign the custom cell provider to the calendar view's customCellProvider.
calendarView.customCellProvider = myCustomCellProvider

````

That's it. The demo app and the migration guide have more information. 

---
***Note:*** Prior to MBCalendarKit, customization of the cell's appearance was limited to properties accessible via `UIAppearance.` Those `UIAppearance` methods are still available in MBCalendarKit 5.0.0.

---

### Calendar Cell Contexts:

If you want to know which date the cell represents, or what scope the cell is being displayed in, look at the context object. `CKCalendarCellContext` has a few interesting properties:

To see the date represented by the cell, use the `date` property.:

```` swift
var date: Date
````

To see if the cell represents today, is out of the month, or even out of range of the calendar's minimum and maximum dates, use the context's `identifier` property, which is one of several `CalendarCellContextIdentifier` values.

```` swift
var identifier: CKCalendarCellContextIdentifier
````

The context identifier is based on several other flags, also available on `CalendarCellContext`. Check out the CocoaDocs generated documentation, or the class header for more.
    

## Calendar Events
`CalendarEvent` is a simple data structure class which holds a title, a date, and an info dictionary. The calendar view will display automatically display `CalendarEvent` objects as passed to it by its data sourcee. If you have custom information that you want to show in a detail view, you can attach it to the event's `info` property. 

As of MBCalendarKit 2.1.0, there's a `color` property as well. Setting it will cause the cell to display a colored "tag" in the cell. This feature should be considered experimental for now.


## Customizing the First Day of the Week:
Version 2.2.0 adds support for the `firstWeekday` property of NSCalendar. If the `currentCalendar` (or whichever you set) has some day other than Sunday set as the first day of the week, the calendar view will respect that.

	/// Instantiate a CalendarViewController or CalendarView.
    let calendarViewController = CKCalendarViewController()

	/// Set the first day of the week to Monday.
    calendarViewController.calendarView.firstWeekDay = 2
    
**About the firstWeekDay property:** Use integers 1-7 to set a weekday from Sunday through Saturday. `NSCalendar` doesn't say what happens if you use another number, so you're on your own if you do that.
  


## Animating Week Transitions
As of MBCalendarKit 5.0.0, `CalendarView` has a `animatesWeekTransitions` property which can be turned on to enable animated transitions in week mode.

---

# Addendum


## Thanks
Dave DeLong, for being an invaluable reference. Thanks to the folks on the iOS Folks Slack team for guidance on nullability and input on working around floating point division precision.

Thank you to the various [contributors]() for patches and reporting issues.

## Want to Contribute?
Learn more about contributing [by clicking here](https://github.com/MosheBerman/MBCalendarKit/blob/master/.github/CONTRIBUTING.md).

## Code Of Conduct
MBCalendarKit adopts the Contributor Covenant Code of Conduct. [Read it here.](https://github.com/MosheBerman/MBCalendarKit/blob/master/.github/CODE_OF_CONDUCT.md)

## License
MBCalendarKit is hereby released under the MIT License. See [LICENSE](/LICENSE) for details.

## Like This?
If you like MBCalendarKit, check out some of my other projects:

- [MBPlacePickerController](https://github.com/MosheBerman/MBPlacePickerController), a one stop shop for all of your CoreLocation needs, including a fallback UI for offline location setup.
- [MBTileParser](https://github.com/MosheBerman/MBTileParser), a cocos-2d compatible game engine written in UIKit.
- [MBTimelineViewController](https://github.com/MosheBerman/MBTimelineViewController), a scrolling timeline based on UICollectionView.
- [MBMenuController](https://github.com/MosheBerman/MBMenuController), a UIActionSheet clone with some nice effects.
