//
//  EventDetailViewController.h
//  MBCalendarKit
//
//  Created by Asif Noor on 4/11/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit.h"
@interface EventDetailViewController : UIViewController
@property (nonatomic,retain) CKCalendarEvent *selectedEvent;

@end
