//
//  CKCache.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/5/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface CKCache : NSObject

// MARK: - Accessing the Shared Cache

/**
 A shared cache for storing things the framework needs to display correctly.
 
 @return The shared cache.
 */
+ (nonnull instancetype)sharedCache;

// MARK: - NSDateFormatter Caching

/**
 Returns a date formatter with the specified format string.
 If the formatter doesn't exist in the cache, we create one.
 
 @param formatString A format string to use.
 @return The format string.
 */
- (nonnull NSDateFormatter *)dateFormatterWithFormat:(nonnull NSString *)formatString;

// MARK: Font

/**
 A font to use in `CKCalendarCell` objects.
 */
@property (nonnull, nonatomic, strong) UIFont *cellFont;

@end
