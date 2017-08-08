# MBCalendarKit 5.0.0 Migration Guide

## Contents

- Introduction
- Auto Layout
- Integrating with Your App as a Dynamic Framework
- CKCalendarViewController and UINavigationController
- A Deeper Look at MBCalendarKit's Autolayout Adoption


### Introduction
If you're using MBCalendarKit 4.0.0 or earlier in an app, wow. (Thank you, and please email me to let me know which app.) MBCalendarKit 5.0.0 is the largest update to the framework since it's initial release, so I'm documenting the breaking changes here. If you have any questions, please feel free to open an issue on GitHub.


### Auto Layout
One of the big updates this release is the adoption of autolayout. In fact, CKCalendarView and friends now *require* it. CKCalendarView will stretch horizontally to fill its superview and vertically to fit the appropriate content.  All you really need to do is add the calendar view to some other view, and constrain it's X and Y position. 

The width is based on the superview, and the height is based on the content. Simple. If you want to embed the calendar in a portion of your screen, you can embed it in a wrapper view.

This system should work well with auto-sized table view cells as well. (Collection views become a little trickier, because self-sizing cells would rely on the calendar for a width, and the calendar would in turn rely on the cell. Again, an appropriately constrained wrapper would fix this problem.) 


### Integrating with Your App as a Dynamic Framework
Prior to 5.0.0, the correct way to use MBCalendarKit was either by dragging a bunch of files into your Xcode project, or by using Cocoapods. With 5.0.0, Cocoapods is still expected to work. The big change here is that MBCalendarKit is now a framework. As a result, you can drag the entire Xcode project into your own and build the framework as a dependency. 

### CKCalendarViewController and UINavigationController
Prior MBCalendarKit 5.0.0, `CKCalendarViewController` subclassed `UINavigationController` and used an internal view controller to present its content.
The tradeoff was that in exchange for a ready-to-go calendar view controller, you couldn't present it inside another navigation controller.  

As of MBCalendarKit 5.0.0, `CKCalendarViewController` no longer automatically wraps itself in a navigation controller. If you were relying on this behavior, you probably want to fix this by embedding the CKCalendarViewController in a `UINavigationController` on your own. It's a one line fix in Objective-C:


    CKCalendarViewController *calendarViewController = [[CKCalendarViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: calendarViewController];
    /* Now, present navigationController */


Here's the same code in Swift:


    let calendarViewController = CKCalendarViewController()
    let navigationController = UINavigationController(rootViewController: calendarViewController)
    // Now, present navigationController here


Really easy, but this small change simplifies the framework and adds enough flexibility to justify the change.


### A Deeper Look at MBCalendarKit's Autolayout Adoption

`CKCalendarView` and adopts auto layout by overriding `intrinsicContentSize`. `CKCalendarHeaderView` stretches to the width of `CKCalendarView` and has a fixed height of 44.0 points. 

Here's how `CKCalendarView` lays itself out:

1. A `CKCalendarView` has an intrinsic content size based on the bounds of its superview. Specifically, intrinsic width is *equal* to the width of the superview. The height is based on width and the `displayMode` of the calendar view. The height is calculated by adding the instrinsic height of the `CKCalendarHeaderView` to the height required to show all of the rows appropriate for the display mode. Put as an equation:

> `headerView.intrinsicContentSize.height + (n * self.computedRowHeight)`

2. The height of a row of cells (`computedRowHeight`) is the width of the calendar view divided by the number of days in the `NSCalendar` instance's week. If you're paying attention, you may have noticed a recursive calculation, because the calendar view's intrinsic width isn't yet known in `intrinsicContentSize`. So, we short-circuit this by using the width of the superview's `bounds` instead.

3. If the calendar view doesn't have a superview, then its intrinsic width is `UIViewNoIntrinsicMetric`, and the view probably won't be able to calculate its intrinsic height. Unless the calendar view is the root view in an app, this won't be a problem. If you do present the calendar view as the root view, you might see an autolayout error like this:

> Failed to rebuild layout engine without detectable loss of precision.  This should never happen.  Performance and correctness may suffer.

There are very few Google/Stack Overflow results for this message, but this answer (by a UIKit Engineer before he joined Apple) has a lot of good info: https://stackoverflow.com/a/27284071/224988 

As a result, if the calendar tries to compute constraints or dimensions based on a nonexistent superview, we just short-circuit the entire method. ls

4. Whenever the calendar view lays out a grid of cells, such as when the selected date changes, it will call `invalidateIntrinsicContentSize` and animate to the appropriate height to fit its content. 
