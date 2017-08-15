//
//  CKCalendarEvent.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

/**
 CKCalendarEvent is a model object which represents an event on the calendar. It has a date property, a title, and an optional info dictionary.
 */
NS_SWIFT_NAME(CalendarEvent)
@interface CKCalendarEvent : NSObject

// MARK: - The Event Date

/**
 The date when the event occurs.
 */
@property (nonatomic, strong) NSDate *date;

// MARK: - The Event Title

/**
 The title for the event.
 */
@property (copy) NSString *title;


/**
 A user info dictionary.
 */
@property (nonatomic, strong) NSDictionary *info;

// MARK: - Customizing Events with Colors and Images

/**
 A color to modify the event with.
 */
@property (nonatomic, strong) UIColor *color;

/**
 An image for to show alongside the event, in the event cell.
 */
@property (strong) NSData *image;

// MARK: - Initializers

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info;
+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andColor:(UIColor *)color;
+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andImage:(NSData *)image;

@end
