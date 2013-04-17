//
//  CKCalendarViewController.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCalendarDataSource.h"
#import "CKCalendarDelegate.h"

@interface CKCalendarViewController : UINavigationController

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate, UINavigationControllerDelegate> delegate;

@end

