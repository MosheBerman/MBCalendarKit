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

@interface CKCalendarViewController : UIViewController

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) CKCalendarView *calendarView;

@end
