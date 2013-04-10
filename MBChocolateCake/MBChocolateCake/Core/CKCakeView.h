//
//  CKCakeCalendarView.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCakeViewModes.h"

@interface CKCakeView : UIView

@property (nonatomic, assign) CKCakeViewMode calendarMode;

@property(nonatomic, strong) NSLocale       *locale;            // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic, copy)   NSCalendar     *calendar;          // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic, strong) NSTimeZone     *timeZone;          // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) NSUInteger firstDayOfTheWeek;     // A NSDateComponents weekday value

/* Calculate the number of weeks in a month - uses the current date */
- (NSUInteger)weeksPerMonth;

/* Calculate the number of weeks in a month - uses the current date */
- (NSUInteger)daysPerMonth;

/* Calculate the number of days in a week - uses the current date*/
- (NSUInteger)daysPerWeek;


@end