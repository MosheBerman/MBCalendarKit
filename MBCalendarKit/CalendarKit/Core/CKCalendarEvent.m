//
//  CKCalendarEvent.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarEvent.h"

@implementation CKCalendarEvent

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info
{
    CKCalendarEvent *e = [CKCalendarEvent new];
    [e setTitle:title];
    [e setDate:date];
    [e setInfo:info];
    
    return e;
}

@end
