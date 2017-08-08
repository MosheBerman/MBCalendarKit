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

@interface CKCalendarHeaderView : UIView

// Appearance
@property (nonatomic, strong) UIFont *headerWeekdayTitleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *headerWeekdayTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *headerWeekdayShadowColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *headerMonthTextFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *headerMonthTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *headerMonthTextShadow UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *headerGradient UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *headerTitleHighlightedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) id<CKCalendarHeaderViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarHeaderViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIGestureRecognizer *tapGesture;


/**
 Causes the header view to reload the contents 
 of the month title label, and the days of the week.
 */
- (void)reloadData;


@end
