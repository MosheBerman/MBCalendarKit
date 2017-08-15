//
//  CKViewController.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface CKCalendarViewController : UIViewController <CKCalendarViewDataSource, CKCalendarViewDelegate>

/**
 The data source provides events to the calendar.
 */
@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;

/**
 The delegate handles interactions with the calendar view controller's calendar view and table view.
 */
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

/**
 The calendar view.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) CKCalendarView *calendarView;

/**
 A table view ahowing events.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UITableView *tableView;

@end
