//
//  CKViewController.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface CKCalendarViewController : UIViewController

@property (nonatomic, strong) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, strong) id<CKCalendarViewDelegate> delegate;

@end
