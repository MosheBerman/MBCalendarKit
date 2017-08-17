//
//  CKCalendarHeaderView.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

@protocol CKCalendarHeaderViewDataSource;
@protocol CKCalendarHeaderViewDelegate;

/**
 The CKCalendarHeaderView provides the month title for calendar and names of the days of the week, where appropriate.
 */
@interface CKCalendarHeaderView : UIView

// MARK: - Configuring the Header View

/**
 The calendar's data source.
 */
@property (nonatomic, weak) id<CKCalendarHeaderViewDataSource> dataSource;

/**
 The calendar's delegate.
 */
@property (nonatomic, weak) id<CKCalendarHeaderViewDelegate> delegate;


// MARK: - Styling the Weekday Labels

/**
 The font to use for each weekday label.
 */
@property (nonatomic, strong) UIFont *headerWeekdayTitleFont UI_APPEARANCE_SELECTOR;

/**
 The color of each weekday label.
 */
@property (nonatomic, strong) UIColor *headerWeekdayTitleColor UI_APPEARANCE_SELECTOR;

/**
 The shadow color of each weekday label.
 */
@property (nonatomic, strong) UIColor *headerWeekdayShadowColor UI_APPEARANCE_SELECTOR;


// MARK: - Styling the Month Label

/**
 The font to use for the month label.
 */
@property (nonatomic, strong) UIFont *headerMonthTextFont UI_APPEARANCE_SELECTOR;

/**
 The text color to use for the month label.
 */
@property (nonatomic, strong) UIColor *headerMonthTextColor UI_APPEARANCE_SELECTOR;

/**
 The text shadow color to use for the month label.
 */
@property (nonatomic, strong) UIColor *headerMonthTextShadow UI_APPEARANCE_SELECTOR;

/**
 The text color for the header when the month is highlighted, such as when the today mode shows the current day.
 */
@property (nonatomic, strong) UIColor *headerTitleHighlightedTextColor UI_APPEARANCE_SELECTOR;

// MARK: - Setting the Header Background

/**
 The background color of the header.
 */
@property (nonatomic, strong) UIColor *headerGradient UI_APPEARANCE_SELECTOR;

// MARK: - Handling Interactions

/**
 The gesture recognizer that handles taps on the next/back buttons. 
 It's accessible here to interact with other gestures in your app, if necessary.
 */
@property (nonatomic, strong, readonly) UIGestureRecognizer *tapGesture;

// MARK: - Reloading the Header

/**
 Causes the header view to reload the contents of the month title label, and the days of the week.
 Useful if you update the locale or calendar properties of the calendar view while the it is visible.
 */
- (void)reloadData;

@end
