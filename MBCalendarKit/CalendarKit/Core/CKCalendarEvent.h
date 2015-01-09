//
//  CKCalendarEvent.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CKCalendarEvent : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) UIColor *color;

@property NSData* image;

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info;
+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andColor:(UIColor *)color;
+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info andImage:(NSData *)image;

@end
