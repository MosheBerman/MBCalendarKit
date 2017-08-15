//
//  NSDateComponents+AllComponents.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDateComponents+AllComponents.h"

@implementation NSDateComponents (AllComponents)

#pragma mark - All Components

+ (NSCalendarUnit)allComponents
{
return (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear);
}

@end
