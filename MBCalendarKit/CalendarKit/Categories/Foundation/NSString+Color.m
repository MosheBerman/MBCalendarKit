//
//  NSString+Color.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSString+Color.h"
#import "UIColor+HexString.h"

@implementation NSString (Color)

/**
 Converts an NSStrig to a color by calling the `colorWithHexString:` method,
 which is defind in `UIColor+HexString.h`.

 @return A `UIColor` which displays the same `RGB` color as the hex string.
 */
- (nullable UIColor *)toColor
{
    return [UIColor colorWithHexString:self];
}

@end
