//
//  CKCalendarEvent.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarEvent.h"

@implementation CKCalendarEvent

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info
{
    CKCalendarEvent *event = [CKCalendarEvent new];
    event.title = title;
    event.date = date;
    event.info = info;
    
    return event;
}

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andColor:(UIColor *)color
{
    CKCalendarEvent *event = [CKCalendarEvent new];
    event.title = title;
    event.date = date;
    event.info = info;
    event.color = color;
    
    return event;
}

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andImage:(NSData *)image
{
    CKCalendarEvent *event = [CKCalendarEvent new];
    event.title = title;
    event.date = date;
    event.info = info;
    event.image = image;
    
    return event;
}

@end
