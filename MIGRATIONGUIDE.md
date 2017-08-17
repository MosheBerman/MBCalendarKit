# MBCalendarKit 5.0.0 Migration Guide

# Contents
- [Contents (You Are Here)](#contents)
- [Introduction](#introduction)
- [Auto Layout](#auto-layout)
- [Cell States](#cell-states)
- [CKCalendarViewController and UINavigationController](#ckcalendarviewcontroller-and-uinavigationcontroller)
- [Customizing Calendar Cell Appearance and Contents](#customizing-calendar-cell-appearance-and-contents)
- [Dropping the Drop Shadow](#dropping-the-drop-shadow)
- [Integrating with Your App as a Dynamic Framework](#integrating-with-your-appa-as-a-dynamic-framework)
- [Who Owns the Events Table](#who-owns-the-events-table)
- [Swift Interoperability](#swift-interoperability)
- [Conclusion](#conclusion)

# Introduction
If you're using MBCalendarKit 4.0.0 or earlier in an app, wow. (Thank you, and please email me to let me know which app.) MBCalendarKit 5.0.0 is the largest update to the framework since it's initial release, so I'm documenting the breaking changes here, to ensure as smooth a transition as possible. Each change has a three parts to make it easy to migrate: Summary, Before, and After. 

My primary goal with this update was to make MBCalendarKit useful again, as a modern, performant calendar library. My secondary goal was to maintain as much backwards compatibility made sense. There are certainly changes to be made in terms of building out new features, but I'm proud of this update and can't wait to see what you do with it. 

I hope that this update and migration guide will go a long way towards these two goals.

[⬆️ <sub>Back To Top</sub>](#contents)


# Auto Layout 

### Summary 
One of the big updates this release is the adoption of autolayout. In fact, CKCalendarView and friends now *require* it. CKCalendarView will stretch horizontally to fill its superview and vertically to fit the appropriate content.  All you really need to do is add the calendar view to some other view, and constrain it's X and Y position. 

The width is based on the superview's width, and the height is based on the content. Simple. If you want to embed the calendar in a portion of your screen, you can embed it in a wrapper view.

This system should work well with auto-sized table view cells as well. (Collection views become a little trickier, because self-sizing cells would rely on the calendar for a width, and the calendar would in turn rely on the cell. Again, an appropriately constrained wrapper would fix this problem.) 

### Before 
In MBCalendarKit 4.x and earlier, you used manual layout by setting the `CKCalendarView`'s frame.

### After
Embed the `CKCalendarView` in a view, and assign vertical and horizontal constraints. (That is, Top/Bottom/CenterY and Leading/Trailing/CenterX constraints.) The view knows how to size itself based on its superview.

### Notes  

**How MBCalendarKit Works with Autolayout**
`CKCalendarView` and adopts auto layout by overriding `- intrinsicContentSize` and `+ requiresConstraintsBasedLayout`. 

Here's how `CKCalendarView` lays itself out:

1. A `CKCalendarView` has an intrinsic content size based on the bounds of its superview. Specifically, intrinsic width is *equal* to the width of the superview. The height is based on width, which is used to calculate the size of each cell. The height is calculated by adding the instrinsic height of the `CKCalendarHeaderView` to the height required to show all of the rows appropriate for the display mode. Put as an equation:

> `headerView.intrinsicContentSize.height + (numberOfVisibleRows * self.computedRowHeight)`

2. The height of a row of cells (`computedRowHeight`) is the width of the calendar view divided by the number of days in the `NSCalendar` instance's week. If you're paying attention, you may have noticed a recursive calculation, because the calendar view's intrinsic width isn't yet known in `intrinsicContentSize`. So, we short-circuit this by using the width of the superview's `bounds` instead. Most calendar systems have seven-day weeks, and most iOS device resolutions don't divide cleanly by 7, so we have to use some tricks to make the display look right. 

3. If the calendar view doesn't have a superview, then its intrinsic width is `UIViewNoIntrinsicMetric`, and the view probably won't be able to calculate its intrinsic height. Unless the calendar view is the root view in an app, this won't be a problem. If you do present the calendar view as the root view, you might see an autolayout error like this:

> Failed to rebuild layout engine without detectable loss of precision.  This should never happen.  Performance and correctness may suffer.

There are very few Google/Stack Overflow results for this message, but this answer (by a UIKit Engineer before he joined Apple) has a lot of good info: https://stackoverflow.com/a/27284071/224988 

As a result, if the calendar tries to compute constraints or dimensions based on a nonexistent superview, we just short-circuit the entire method. The short answer here is don't do this. If you want the calendar view to be the root view, use a `CKCalendarViewController` instead.

**Adoption Takeaways**

1. Another interesting thing I learned is that Storyboard based views have a default bounds of 600x600px. This is changed when the view moves to the window, so we do a layout pass in `didMoveToWindow`, to ensure that the `intrinsicContentSize` is correct.

2. Interface Builder uses autoresizing mask-based constraints, so in an `IBDesignable`, you _don't_ want to turn off `translatesAutoresizingMasksIntoConstraints`. MBCalendarKit uses `#if TARGET_INTERFACE_BUILDER` to handle this.

3. Whenever the calendar view lays out a grid of cells, such as when the selected date changes, it will call `invalidateIntrinsicContentSize` and animate to the appropriate height to fit its content. 

[⬆️ <sub>Back To Top</sub>](#contents)


# Cell States 
### Summary 
In MBCalendarKit 4.x.x and prior, cells had a "state" property defined as an enum type called `CKCalendarMonthCellState`. It was intended to serve as a combination of the context that the cell was in (today, selected date, the same month as the selected date, etc) and the cell's highlighted/selected state. 

In MBCalendarKit 5.0.0, this has changed, to be more compatible with `UICollectionView` and `CKCustomCellClass`. The enum is now called `CKCalendarCellContextIdentifier` and no longer captures cell highlighting or selection semantics. This property might not impact your code directly, but if you work with the new `CKCustomCellAppearance` protocol, be aware of this. 

There is a `typealias`, so your existing code will compile, but the old enums are deprecated, and the new code doesn't attempt to map them. Use Xcode's fixit suggestions to migrate.

### Before
Use `CKCalendarMonthCellState` to describe how the cell is being used and if it's highlighted or selected.

### After
Use `CKCalendarContextIdentifier` and `UICollectionViewCell`'s `isHighlighted` and `isSelected` properties to get the information you want.
[⬆️ <sub>Back To Top</sub>](#contents)


# CKCalendarViewController and UINavigationController 
### Summary
Prior MBCalendarKit 5.0.0, `CKCalendarViewController` subclassed `UINavigationController` and used an internal view controller to present its content. The tradeoff was that in exchange for a ready-to-go calendar view controller in a navigation controller, you couldn't present it inside another navigation controller.

As of MBCalendarKit 5.0.0, `CKCalendarViewController` no longer automatically wraps itself in a navigation controller. If you were relying on this behavior, you probably want to fix this by embedding the CKCalendarViewController in a `UINavigationController` on your own.

### Before 
Use `CKCalendarViewController` for a calendar wrapped in a `UINavigationController`. 

### After 
It's a one line fix in Objective-C:

    CKCalendarViewController *calendarViewController = [[CKCalendarViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: calendarViewController];
    /* Now, present navigationController. */


Here's the same code in Swift:

    let calendarViewController = CKCalendarViewController()
    let navigationController = UINavigationController(rootViewController: calendarViewController)
    // Now, present navigationController.

Notice that there's only one extra line of code. Really easy, but this small change simplifies the framework and adds enough flexibility to justify the change.

[⬆️ <sub>Back To Top</sub>](#contents)


# Customizing Calendar Cell Appearance and Contents 
### Summary
A brand new API was added, to allow for complete customization of calendar cells. Previously, you had to use `UIAppearance` to customize select properties of `CKCalendarCell`. While this option is still available to you, you can also provide your own cell classes by adopting the  `CKCustomCellProvider` protocol and setting the calendar view's `customCellProvider` property.

### Before
Use `UIAppearance` on the `CKCalendarHeaderView` and `CKCalendarCell` classes to customize calendar appearance.

### After
Use `UIAppearance` or `CKCustomCellProviding` to customize cells. Customizing the header view still requires `UIAppearance` in 5.0.0.

[⬆️ <sub>Back To Top</sub>](#contents)


# Dropping the Drop Shadow 
### Summary 
The original iPhone calendar had a nice and heavy drop shadow on it, to give a sense of depth. MBCalendarKit versions prior to 5.0.0 included this drop shadow. However, as the library moves towards the modern design standards, this is no longer enabled on `CKCalendarView` by default. You still do get this behavior on `CKCalendarViewController`, which has taken over the responsibility of displaying the table view. 

### Before 
`CKCalendarViewController` and standalone `CKCalendarView` both included the drop shadow automatically.

### After
The drop shadow is only added by `CKCalendarViewController`.If you want the same drop shadow on a calendar view, you can add it yourself with this code:


(calendarView.layer).shadowColor = [UIColor darkGrayColor].CGColor;
(calendarView.layer).shadowOffset = CGSizeMake(0, 3);
(calendarView.layer).shadowOpacity = 1.0;

[⬆️ <sub>Back To Top</sub>](#contents)


# Integrating with Your App as a Dynamic Framework 
### Summary
Prior to 5.0.0, the correct way to use MBCalendarKit was either by dragging a bunch of files into your Xcode project, or by using Cocoapods. With 5.0.0, Cocoapods is still expected to work. The big change here is that MBCalendarKit is now a framework. As a result, you can drag the entire Xcode project into your own and build the framework as a dependency.

### Before 
Use Cocoapods or drag in some flat files.

### After 
Use Cocoapods, or, drag the MBCalendarKit Xcode project into your own and then add `MBCalendarKit.framework` as a dependency. 

[⬆️ <sub>Back To Top</sub>](#contents)


# Who Owns the Events Table
### Summary
Prior to MBCalendarKit 5.0.0, the `CKCalendarView` owned an events table, which embed it into whatever its superview was. In MBCalendarKit 5.0.0, this changes. You still use the same data source and delegate protocols, but now if you want the table, you need to use `CKCalendarViewController` instead of `CKCalendarView`.

There are two parts to why this change was made:
1. Autolayout: With the introduction of autolayout, `CKCalendarView` becomes increasingly likely to be used in more places. To make the control more flexible, the `CKCalendarViewController` takes over the responsibility of installing, displaying, and updating the events table, and the `CKCalendarView` is free to remain a flexible calendar display.
2. Interface Builder: `CKCalendarView` installed the events table inside of its superview, but outside of its own bounds. This was fine, but it makes it difficult to hide the table where it isn't wanted, and it can be confusing to see a table view preview in Interface Builder that doesn't respond to clicks because it's outside the calendar view's bounds. 

### Before
Use `CKCalendarView` to show the calendar and the events table. Use the `CKCalendarView`'s data source to display the events in the table and its delegate to handle interaction with the event table. 
 
### After 
If you want to embed the calendar and a table inside of a view, use `CKCalendarViewController` and use the same data source and delegate methods. Alternatively, manage the table view yourself.

### Notes
`CKCalendarView` still cares about the data source, because it shows dots in cells representing dates that have corresponding events.

[⬆️ <sub>Back To Top</sub>](#contents)


# Swift Interoperability 
### Summary
To better support Swift interoperability, several changes were made:

1. A full nullability audit has been done. As a result, some of the delegate methods have changed to no longer require force-unwrap operators on their parameters.
2. The `CKCalendarDisplayMode` enum was renamed to `CKCalendarViewDisplayMode` and the `CKCalendarViewMode...` prefixed enum cases have been deprecated in favor of `CKCalendarViewDisplayMode...` enum cases. This should simplify use of display modes in Swift. A similar change was made to the `CKCalendarMonthCellState` enum. This enum is now called `CKCalendarCellContextIdentifier` in Objective-C and `CalendarCellContextIdentifier` in Swift. There are `typealias` definitions, so your existing code will compile, but the old enums are deprecated, and the new code doesn't attempt to map them. Use Xcode's fixit suggestions to migrate.
3. Classes with the `CK` prefix in Objective-C were given `NS_SWIFT_NAME()` annotations. `CKCalendarView` becomes `CalendarView`, `CKCalendarCell` becomes `CalendarCell` etc.   

### Before
You may have noticed some enum names that weren't semantically quite right, or force unwraps in the data source and delegate methods. 

### After 
Adjust to use the new enum names and updated method signatures.

### Notes
One way to easily adopt these changes is to link against the new framework and then try to build. The Swift compiler should fail at all of the important parts. Just re-type the data source and delegate method headers and verify enum names wherever you use them. (Let Xcode's 'autocomplete help out with this.)

[⬆️ <sub>Back To Top</sub>](#contents)


# Conclusion

I hope this was helpful. There are some cool new changes around cell customization, as well as an awesome new demo app, so check it out!

[⬆️ <sub>Back To Top</sub>](#contents)
