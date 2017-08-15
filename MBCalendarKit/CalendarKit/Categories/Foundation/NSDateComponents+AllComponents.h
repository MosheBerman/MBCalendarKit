//
//  NSDateComponents+AllComponents.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import Foundation;

@interface NSDateComponents (AllComponents)


/**
 Combines all of the `NSCalendarUnit` values for a value with all of the flags enabled.

 @return All of the `NSCalendarUnit` flags.
 */
+ (NSCalendarUnit)allComponents;

@end
