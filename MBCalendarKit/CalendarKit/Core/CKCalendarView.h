//
//  CKCalendarCalendarView.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCalendarViewModes.h"

#import "CKCalendarEvent.h"

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface CKCalendarView : UIView

@property (nonatomic, assign) CKCalendarDisplayMode displayMode;

@property(nonatomic, strong) NSLocale       *locale;            // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic, copy)   NSCalendar     *calendar;          // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic, strong) NSTimeZone     *timeZone;          // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;


@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

/* Initializer */

- (id)init;
- (id)initWithMode:(CKCalendarDisplayMode)CalendarDisplayMode;

/* Reload calendar and events. */

- (void)reload;
- (void)reloadAnimated:(BOOL)animated;

/* Setters */

- (void)setCalendar:(NSCalendar *)calendar;
- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated;

- (void)setDate:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode;
- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated;

- (void)setLocale:(NSLocale *)locale;
- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated;

- (void)setTimeZone:(NSTimeZone *)timeZone;
- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated;

- (void)setMinimumDate:(NSDate *)minimumDate;
- (void)setMinimumDate:(NSDate *)minimumDate animated:(BOOL)animated;

- (void)setMaximumDate:(NSDate *)maximumDate;
- (void)setMaximumDate:(NSDate *)maximumDate animated:(BOOL)animated;

/* Visible Dates */

- (NSDate *)firstVisibleDate;
- (NSDate *)lastVisibleDate;

@end
