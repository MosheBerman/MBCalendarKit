![Promo](https://github.com/MosheBerman/MBCalendarKit/raw/master/Promo.png)

About: 
---
MBCalendarKit is a calendar control written in UIKit. I've found existing implementations to be inadequate and difficult to work with, so I rolled my own.

Getting Started:
---------------

You'll need to set up the dependencies, described below. Alternatively, MBCalendarKit is now a registered CocoaPod. I don't use CocoaPods, but I did run a quick test on using the following line in my Podfile:

`pod 'MBCalendarKit', '~>5.0.0'`

If there are any problems, please head over to issue #48 and leave a comment.


Dependencies:
-------------

You'll need the iOS 8 SDK or newer. 

Relevant Files:
---------------

Aside from the framework dependencies described above, you'll want everything in the CalendarKit folder.

Working With Swift:
------------------------

Swift supports Objective-C code interoperability with what Apple is calling "[Mix and Match](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)." 

To expose MBCalendarKit to Swift, just link against it. Wherever you want to use it, simply `import MBCalendarKit`.

MBCalendarKit 5.0.0 includes a number of Swift enhancements. For specifics, check out the [Migration Guide](./MIGRATIONGUIDE.md).


Showing a Calendar
--------------------------------------

You have two choices for showing a calendar using MBCalendarKit. For both of them, you'll need to import the library:



1. You can show an instance of `CKCalendarView`. Use this if you want to manually manage your view hierarchy or just want a calendar view without the table view or event management.


```` objective-c

/*
Here's how you'd show a CKCalendarView from within a view controller. 
It's just three easy steps after importing the library.
*/
		
// 0. In either case, import CalendarKit:
@import MBCalendarKit;
    	
// 1. Instantiate a CKCalendarView
CKCalendarView *calendar = [CKCalendarView new];
 		
// 2. Present the calendar 
[self.view addSubview:calendar];

// 3. Add positioning constraints:
self.calendarView.translatesAutoresizingMaskIntoConstraints = NO;
[calendarView.topAnchor constraintEqualTo:self.topLayoutGuide.bottomAnchor].isActive = YES;
[calendarView.centerXAnchor constraintEqualTo:self.view.centerXAnchor].isActive = YES;

````



2. Your second option is to create an instance of `CKCalendarViewController`. Using a CKCalendarViewController gives you the added benefit of a "today" button and a segmented control in the toolbar, which allows you to select the display mode. In MBCalendarKit 5.0.0 and later, you also use `CKCalendarViewController` if you'd like an events table view.

---
***Note:*** In older versions of MBCalendarKit, `CKCalendarViewController` used to subclass `UINavigationViewController`, so it couldn't be installed inside of another navigation controller. In 5.0.0, this is no longer the case. If you wish to embed your calendar inside a `UINavigationViewController`, you must now install it on your own. See the [Migration Guide](./MIGRATIONGUIDE.md) for details.

---


```` objective-c

/* 
Here's how you'd show a CKCalendarViewController from 
within a view controller. It's just three easy steps.
*/
		
// 1. In either case, import CalendarKit:
@import MBCalendarKit;
    	
// 2. Instantiate a CKCalendarViewController
CKCalendarViewController *calendar = [CKCalendarViewController new];
 		
// 3. Present the calendar 
[[self presentViewController:calendar animated:YES completion:nil];
		
````

With both `CKCalenderView` and `CKCalendarViewController`, you can use the `dataSource` and `delegate` properties to display events, and get information about user interation.

In MBCalendarKit 5.0.0, there's a new property on `CKCalendarView` called `CKCustomCellProvider`, which can be used to customize the display of the cells in a really powerful way. Keep reading to learn more about setting up events

---

**Note: From this point on, both the CKCalendarView class and the CKCalendarViewController classes are interchangeably referred to as the "calendar view", because they have common datasource and delegate APIs. Where the two differ, specifically the new `CKCustomCellProvider` API, an explicit class name is used instead.** 

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

**Note:** The dates used as keys must match the dates passed into the data source method exactly. One way to ensure this is to use the `NSCalendar`'s `[calendar isDate:equalToDate:toUnitGranularity:]`, passing in the two dates and `NSCalendarUnitDay` as the third argument, to create the dates you pass to your events.

You can also see this code in `CKDemoViewController.m` in the demo app.
		
Handling User Interaction
-------------------------

These methods, defined in the `CKCalendarViewDelegate` protocol, are called on the delegate when the used selects a date. A date is considered selected when either an arrow in the header is tapped, or when the user lifts their finger from a cell.

```` objective-c
- (void)calendarView:(nonnull CKCalendarView *)calendarView willSelectDate:(nonnull NSDate *)date;
- (void)calendarView:(nonnull CKCalendarView *)calendarView didSelectDate:(nonnull NSDate *)date;
````  

This method is called on the delegate when a row is selected in the events table. You can use to push a detail view, for example.

```` objective-c
- (void)calendarView:(nonnull CKCalendarView *)CalendarView didSelectEvent:(nonnull CKCalendarEvent *)event;
````   

Customizing Cells
----------------- 

MBCalendarKit 5.0.0 brings a brand new way to customize cells, so that you can add your own data to the cells, or even do a completely design. By building on top of `UICollectionView`, MBCalendarKit provides a really simple API. First, you need to implement `CKCustomCellProviding` in your code. This is composed of two parts: First, telling MBCalendarKit which UICollectionViewCell subclass to use for the cells, and second, implementing a method callback which will be your opportunity to customize the cell based on its context.

Let's look at an implementation based on the default implementation:

```` objective-c

// Step 1. Formally adopt the `CKCustomCellProviding` protocol
@interface MyCustomCellProvider: () <CKCustomCellProviding>
@end

@implementation MyCustomCellProvider 

// Step 2. Inform the framework of your `UICollectionViewCell` subclass, so it knows to use it.
- (nonnull Class)customCellClass;
{
    return CKCalendarCell.class;
}

// Step 3. Implement the custom cell delegate callback
- (void)calendarView:(nonnull CKCalendarView *)calendarView willDisplayCell:(nonnull UICollectionViewCell *)cell inContext:(nonnull CKCalendarCellContext *)context;
{
    // It's reasonable to cast to whatever class is in `customCellClass`.
    CKCalendarCell *calendarCell = (CKCalendarCell *)cell;

    // Customize the cell's contents and display here.
}
````

Now, simply tell the calendar view that your object is providing custom cells:

```` objective-c
// 0. Assume an existing calendarView

// 1. Instantiate your custom cell provider.
id<CKCustomCellProvider> *myCustomCellProvider = [[MyCustomCellProviderClass alloc] init];

// 2. Assign the custom cell provider to the calendar view's customCellProvider.
calendarView.customCellProvider = myCustomCellProvider;

````

That's it. The demo app and the migration guide have more information. 

---
***Note:** Prior to MBCalendarKit, customization of the cell's appearance was limited to properties accessible via `UIAppearance.` Those `UIAppearance` methods are still available in MBCalendarKit 5.0.0.*

---

Calendar Cell Contexts:
----------------------

If you want to know which date the cell represents, or what scope the cell is being displayed in, look at the context object. `CKCalendarCellContext` has a few interesting properties:

To see the date represented by the cell, use the `date` property.:

```` objective-c
@property (nonatomic, strong, nonnull) NSDate *date;
````

To see if the cell represents today, is out of the month, or even out of range of the calendar's minimum and maximum dates, use the context's `identifier` property, which is one of several `CKCalendarCellContextIdentifier` values.

```` objective-c
@property (nonatomic, assign, readonly) CKCalendarCellContextIdentifier identifier;
````

The context identifier is based on several other flags, also available on `CKCalendarCellContext`. Check out the CocoaDocs generated documentation, or the class header for more.
    
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
