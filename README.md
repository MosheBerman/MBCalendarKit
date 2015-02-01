![Promo](https://github.com/MosheBerman/MBCalendarKit/raw/master/Promo.png)

About: 
---
MBCalendarKit is a calendar control written in UIKit. I've found existing implementations to be inadequate and difficult to work with, so I rolled my own.

Getting Started:
---------------

You'll need to set up the dependencies, described below. Alternatively, MBCalendarKit is now a registered CocoaPod. I don't use CocoaPods, but I did run a quick test on using the following line in my Podfile:

`pod 'MBCalendarKit', '~>3.0.4'`

If there are any problems, please head over to issue #48 and leave a comment.


Dependencies:
-------------

You'll need the iOS 7 SDK or newer. With the addition of the Swift demo in 3.0.0, MBCalendarKit will no longer deploy to iOS 6.'

As of MBCalendarKit 2.0.0, the project uses the LLVM compiler's modules feature. 

MBCalendarKit requires Quartz, Core Graphics, UIKit, and Foundation. The Unit Tests build against the XCTest framework. Xcode should take care of all those except `QuartzCore.framework`. If you're building the tests, you may have to link to XCTest yourself, as well.

Relevant Files:
---------------

Aside from the framework dependencies described above, you'll want everything in the CalendarKit folder.

Working With Swift:
------------------------

Swift supports Objective-C code interoperability with what Apple is calling "[Mix and Match](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)."

Add the following files to your `*ProjectName*-Bridging-Header.h`:

```` objective-c
#import "CalendarKit.h"
#import "CKDemoViewController.h"
#import "NSCalendarCategories.h"
#import "NSDate+Components.h"
````

You should be able to use MBCalendarKit in your Swift classes. There's an example in the demo app. Look at CKAppDelegate.

Showing a Calendar
--------------------------------------

You have two choices for showing a calendar using MBCalendarKit. 

1. You can show an instance of `CKCalendarView`. Use this if you want to manually manage your view hierarchy or have a finer control over your calendar view.


```` objective-c

/*
Here's how you'd show a CKCalendarView from within a view controller. 
It's just four easy steps.
*/
		
// 0. In either case, import CalendarKit:
#import "CalendarKit/CalendarKit.h"
    	
// 1. Instantiate a CKCalendarView
CKCalendarView *calendar = [CKCalendarView new];
 		
// 2. Optionally, set up the datasource and delegates
[calendar setDelegate:self];
[calendar setDataSource:self];
 		
// 3. Present the calendar 
[[self view] addSubview:calendar];
		
````


2. Your second option is to create an instance of `CKCalendarViewController`. Using a CKCalendarViewController gives you the added benefit of a "today" button and a segmented control in the toolbar, which allows you to select the display mode. Note that `CKCalendarViewController` subclasses `UINavigationViewController`, so it can't be installed inside of another navigation controller. 


```` objective-c

/* 
Here's how you'd show a CKCalendarViewController from 
within a view controller. It's just four easy steps.
*/
		
// 0. In either case, import CalendarKit:
#import "CalendarKit/CalendarKit.h"
    	
// 1. Instantiate a CKCalendarViewController
CKCalendarViewController *calendar = [CKCalendarViewController new];
 		
// 2. Optionally, set up the datasource and delegates
[calendar setDelegate:self];
[calendar setDataSource:self];
 		
// 3. Present the calendar 
[[self presentViewController:calendar animated:YES completion:nil];
		
````

---

**Note: From this point on, both the CKCalendarView class and the CKCalendarViewController classes are interchangeably referred to as the "calendar view", because they have common datasource and delegate APIs.** 

---



Showing Events
-------------------------

The `CKCalendarDataSource` protocol defines a method, which supplies an array of `CKCalendarEvent` objects. The calendar view automatically shows an indicator in cells that represent dates that have events. 

```` objective-c
- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date;
````
In your data source, implement this method and return the events matching the date being passed in.

Here's an example of adding a few events to the calendar:

	- (void)viewDidLoad {
      [super viewDidLoad];
    
      // 0. Create a dictionary for the data source
      self.data = [[NSMutableDictionary alloc] init];
    
      // 1. Wire up the data source and delegate.
      [self setDataSource:self];
      [self setDelegate:self];
    
      // 2. Create some events.
    
      NSString *title = NSLocalizedString(@"Release MBCalendarKit 2.2.4", @"");
      NSDate *date = [NSDate dateWithDay:28 month:11 year:2014];
      CKCalendarEvent *releaseUpdatedCalendarKit = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil];
    
      NSString *title2 = NSLocalizedString(@"The Hunger Games: Mockingjay, Part 1", @"");
      NSDate *date2 = [NSDate dateWithDay:21 month:11 year:2014];
      CKCalendarEvent *mockingJay = [CKCalendarEvent eventWithTitle:title2 andDate:date2 andInfo:nil];

      NSString *title3 = NSLocalizedString(@"Integrate MBCalendarKit", @"");
      NSDate *date3 = date2;
      CKCalendarEvent *integrationEvent = [CKCalendarEvent eventWithTitle:title3 andDate:date3 andInfo:nil];
    
      //	4. 	Add the events to the backing dictionary.
      //		The keys are NSDate objects that must
      //		match the ones passed data source method.
      self.data[date] = @[releaseUpdatedCalendarKit];
      self.data[date2] = @[mockingJay, integrationEvent];	  // multiple events on one date.
    }
    
Now, implement the data source:
    
    #pragma mark - CKCalendarViewDataSource

    - (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
    {
        return [self data][date];
    }

**Note:** The dates used as keys must match the dates passed into the data source method exactly. One way to ensure this is to use the `dateWithDay:month:year` method defined in the `NSDate+Components.m` category to create the dates you pass to your events.

You can also see this code in `CKDemoViewController.m` in the demo app.
		
Handling User Interaction
-------------------------

These methods, defined in the `CKCalendarViewDelegate` protocol, are called on the delegate when the used selects a date. A date is considered selected when either an arrow in the header is tapped, or when the user lifts their finger from a cell.

```` objective-c
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date;
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date;
````  

This method is called on the delegate when a row is selected in the events table. You can use to push a detail view, for example.

```` objective-c
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event;
````   
    
Calendar Events
----------------
`CKCalendarEvent` is a simple data structure class which holds a title, a date, and an info dictionary. The calendar view will display automatically display `CKCalendarEvent` objects as passed to it by its data sourcee. If you have custom information that you want to show in a detail view, you can attach it to the event's `info` property. 

As of MBCalendarKit 2.1.0, there's a `color` property as well. Setting it will cause the cell to display a colored "tag" in the cell. This feature should be considered experimental for now.

Day of the Week:
---
Version 2.2.0 adds support for the `firstWeekday` property of NSCalendar. If the `currentCalendar` (or whichever you set) has some day other than Sunday set as the first day of the week, the calendar view will respect that.

	//	0. Instantiate a calendarViewController. (You can use a calendarView directly.)
    CKCalendarViewController *calendarViewController = [CKCalendarViewController new];

	//	1. Set the first day of the week to Monday.
    calendarViewController.calendarView.firstWeekDay = 2;
    
**About the firstWeekDay property:** Use integers 1-7 to set a weekday from Sunday through Saturday. Using other numbers is not documented in the `NSCalendar` documentation.

License:
========

MBCalendarKit is hereby released under the MIT License. See [LICENSE](/LICENSE) for details.

Thanks:
-------
Dave DeLong, for being an invaluable reference.

Various contributors for patches and reporting issues.

If you like this...
---
If you like MBCalendarKit, check out some of my other projects:

- [MBPlacePickerController](https://github.com/MosheBerman/MBPlacePickerController), a one stop shop for all of your CoreLocation needs, including a fallback UI for offline location setup.
- [MBTileParser](https://github.com/MosheBerman/MBTileParser), a cocos-2d compatible game engine written in UIKit.
- [MBTimelineViewController](https://github.com/MosheBerman/MBTimelineViewController), a scrolling timeline based on UICollectionView.
- [MBMenuController](https://github.com/MosheBerman/MBMenuController), a UIActionSheet clone with some nice effects.
