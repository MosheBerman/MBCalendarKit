//
//  NSDate+Description.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Description)

- (NSString *)description;

// Returns a three letter abbreviation of weekday name
- (NSString *)dayNameOnCalendar:(NSCalendar *)calendar;

//  Prints out "January", "February", etc for Gregorian dates.
- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar;

//  Prints out "January", "February", etc for Gregorian dates.
- (NSString *)monthNameAndYearOnCalendar:(NSCalendar *)calendar;


//  Prints out "Jan", "Feb", etc for Gregorian dates.
- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar;


@end
