//
//  CKCakeCalendarView.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCakeViewModes.h"

#import "CKCakeEvent.h"

@class CKCakeView;


@protocol CKCakeViewDataSource <NSObject>

- (NSArray *)cakeView:(CKCakeView *)cakeView eventsForDate:(NSDate *)date;

@end

@protocol CKCakeViewDelegate <NSObject>

@optional

// Called before/after the selected date changes
- (void)cakeView:(CKCakeView *)cakeView willSelectDate:(NSDate *)date;
- (void)cakeView:(CKCakeView *)cakeView didSelectDate:(NSDate *)date;

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)cakeView:(CKCakeView *)cakeView didSelectEvent:(CKCakeEvent *)event;

@end

@interface CKCakeView : UIView

@property (nonatomic, assign) CKCakeDisplayMode displayMode;

@property(nonatomic, strong) NSLocale       *locale;            // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic, copy)   NSCalendar     *calendar;          // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic, strong) NSTimeZone     *timeZone;          // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) id<CKCakeViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCakeViewDelegate> delegate;

- (id)initWithMode:(CKCakeDisplayMode)cakeDisplayMode;

- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (void)setDisplayMode:(CKCakeDisplayMode)displayMode animated:(BOOL)animated;
- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated;
- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated;


@end
