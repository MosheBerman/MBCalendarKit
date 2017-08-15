//
//  UIColor+HexString.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//


@import UIKit;

@interface UIColor (HexString)

/**
 Converts a string representation of a hexidecimal value to a `UIColor`.

 Taken from this Stack Overflow answer: http://stackoverflow.com/a/7180905/224988
 
 @param hexString The hexidecimal string to convert.
 @return A `UIColor` if the input string was valid. Otherwise this method will raise an exception.
 */
+ (nullable UIColor *)colorWithHexString:(nonnull NSString *)hexString;

@end
