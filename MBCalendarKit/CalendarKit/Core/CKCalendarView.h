//
//  CKCalendarCalendarView.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarViewDisplayMode.h"
#import "CKCalendarEvent.h"
#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"
#import "CKCustomCellProviding.h"


NS_SWIFT_NAME(CalendarView)
IB_DESIGNABLE @interface CKCalendarView : UIView

// MARK: - Initializers

/**
 Initialize an instance of CKCalendarView.
 
 @param mode The display mode to use.
 @return An instance of CKCalendarView.
 */
- (instancetype _Nonnull)initWithMode:(CKCalendarViewDisplayMode)mode NS_DESIGNATED_INITIALIZER;

// MARK: - Display Mode

/**
 The display mode determines how much information the calendar shows at once.
 */
@property (nonatomic, assign) CKCalendarViewDisplayMode displayMode;

/**
 Sets the display mode of the calendar view.
 
 @param mode A valid CKCalendarViewMode value.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setDisplayMode:(CKCalendarViewDisplayMode)mode animated:(BOOL)animated;


// MARK: - Getting and Setting the Backing NSCalendar

/**
 The calendar system used to display the calendar view.
 
 This is used for things like the names of the months and how many weeks are required to display a given month.
 
 The default is `NSCalendar.currentCalendar`. Setting to `nil` restores the default.
 */
@property(nonatomic, copy, nonnull) NSCalendar *calendar;

/**
 Set the `NSCalendar` backing the calendar view.
 
 @param calendar An `NSCalendar` instance.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setCalendar:(NSCalendar * _Nonnull)calendar animated:(BOOL)animated;

// MARK: - The Format Locale

/**
 The locale that the calendar view uses to format things, such as week names.
 
 The default is `NSLocale.currentLocale`. Setting to `nil` restores the default.
 */
@property(nonatomic, strong) NSLocale * _Nonnull locale;

/**
 Sets the locale that the calendar view uses to format things, such as week names.
 
 @discussion See CKCalendarView.locale for information about default values.
 
 @param locale An `NSLocale` instance.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setLocale:(nonnull NSLocale *)locale animated:(BOOL)animated;


// MARK: - Getting and Setting the Time Zone

/**
 A proxy for the `self.calendar.timeZone`, where self is an instance of CKCalendarView.
 
 This is used for things such as determining which date a given event applies to.
 
 @discussion Prior to 5.0.0, the default was `nil`, and setting this to nil would cause the calendar's time zone to be set to `NSTimeZone.localTimeZone`.
 
 MBCalendarKit 5.0.0 changed this property, so that accessing the property returns the `self.calendar.timeZone`. 
 As a result, the default value is now `NSTimeZone.defaultTimeZone`. To make the setter consistent with this, setting to `nil` now sets to `NSTimeZone.defaultTimeZone`.
 
 */
@property(nonatomic, strong, nonnull) NSTimeZone *timeZone;

/**
 Sets the time zone on `self.calendar`.
 
 @discussion See CKCalendarView.timeZone for information about default values.
 
 @param timeZone An `NSTimeZone` instance.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setTimeZone:(NSTimeZone * _Nonnull)timeZone animated:(BOOL)animated;


// MARK: - Getting and Setting the Current Date

/**
 The currently selected date on the calendar.
 */
@property (nonatomic, strong, nonnull) NSDate *date;

/**
 Set the selected `date` property on the calendar vies.
 
 @param date An `NSDate` instance.
 
 @discussion If `minimumDate` or `maximumDate` are set, and the `date` is out of range, it will be clamped to the appropriate bounding date.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setDate:(nonnull NSDate *)date animated:(BOOL)animated;


// MARK: - Clamping the Minimum Date

/**
 Returns the value of the calendar's `minimumDate` if it is set.
 
 When set, this prevents dates later to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 
 @return The calendar's minimum date, or `nil`.
 */
@property (NS_NONATOMIC_IOSONLY, copy) NSDate * _Nullable minimumDate;

/**
 Calls `setMinimumDate:animated:` with the date provided as the `minimumDate` and `NO` for `animated`.

 @param minimumDate The date to set as the minimum date.
 */

/**
 Sets the minimum date with an optional animation.

 @param minimumDate The minimum date the calendar view allows to display or be interacted with.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setMinimumDate:(nullable NSDate *)minimumDate animated:(BOOL)animated;


// MARK: - Clamping the Maximum Date

/**
 Returns the value of the calendar's `maximumDate` if it is set.
 
 When set, this prevents dates later to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 
 @return The calendar's maximum date, or `nil`.
 */
@property (NS_NONATOMIC_IOSONLY, copy) NSDate * _Nullable maximumDate;

/**
 Calls `setMaximumDate:animated:` with the date provided as the `maximumDate` and `NO` for `animated`.
 
 @param maximumDate The date to set as the minimum date.
 */

/**
 Sets the maximum date with an optional animation.

 @param maximumDate The maximum date the calendar view allows to display or be interacted with.
 @param animated Determines if the layout pass that this triggers should animate.
 */
- (void)setMaximumDate:(nullable NSDate *)maximumDate animated:(BOOL)animated;


// MARK: - Customizing the First Day of the Week

/**
 An integer value from 1-7, specifying the first day of the week.
 On the gregorian calendar, 1 is Sunday, 2 is Monday, etc.
 
 The first weekday is shown in the leading column of the calendar.
 */
@property (nonatomic, assign) NSUInteger firstWeekDay;

// MARK: - Displaying Data in the Calendar View

/**
 The data source which provides events for the calendar.
 */
@property (nonatomic, weak, nullable) id<CKCalendarViewDataSource> dataSource;

// MARK: - Handling Interaction with the Calendar

/**
 The delegate handles date changes and event selections.
 */
@property (nonatomic, weak, nullable) id<CKCalendarViewDelegate> delegate;

/**
 An object that can provide custom calendar cells.
 */
@property (nonatomic, weak, nullable) id<CKCustomCellProviding> customCellProvider;

// MARK: - Reloading the Calendar and Event Table

/**
 Reload the calendar view by calling `[self reloadAnimated:NO]`.
 */
- (void)reload;

/**
 Reloads the calendar, optionally with animation.
 
 @discussion Reloading the calendar view asks the calendar view's data source for the events matching the `date` property. The calendar then sorts the events by date and caches them before rendering the new visual state of the calendar, including the header and table views.
 
 @param animated Determines if the calendar should animate from the old state to the new state.
 */
- (void)reloadAnimated:(BOOL)animated;


// MARK: - Animating Week Transitions

/**
 Determines if the calendar view should animate from week to week.
 
 Prior to MBCalendarKit 5.0.0, only month transitions animated. 
 With this enabled, week to week transitions can animate as well.
 
 The default value is `NO`, to remain consistent with the legacy iPhone calendar.
 */
@property (nonatomic, assign) BOOL animatesWeekTransitions;

@end
