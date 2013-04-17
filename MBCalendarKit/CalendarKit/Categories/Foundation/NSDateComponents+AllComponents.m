//
//  NSDateComponents+AllComponents.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDateComponents+AllComponents.h"

@implementation NSDateComponents (AllComponents)

#pragma mark - All Components

+ (NSUInteger)allComponents
{
return (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit);
}

@end
