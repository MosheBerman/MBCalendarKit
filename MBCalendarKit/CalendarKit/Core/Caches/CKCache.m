//
//  CKCache.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/5/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCache.h"

@import UIKit;

@interface CKCache ()

/**
 A cache of NSDateFormatters by format string.
 */
@property (nonatomic, strong, nonnull) NSMutableDictionary <NSString *, NSDateFormatter *> *formatters;


@end

@implementation CKCache

// MARK: - Accessing the Shared Cache

/**
 A shared cache for storing things the framework needs to display correctly.

 @return The shared cache.
 */
+ (nonnull instancetype)sharedCache;
{
    static CKCache *cache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[CKCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:cache selector:@selector(purge) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    
    return cache;
}

// MARK: - Initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _formatters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// MARK: - Responding to Memory Pressure

- (void)purge
{
    [_formatters removeAllObjects];
}

// MARK: - NSDateFormatter Caching

/**
 Returns a date formatter with the specified format string. 
 If the formatter doesn't exist in the cache, we create one.

 @param formatString A format string to use.
 @return The format string.
 */
- (nonnull NSDateFormatter *)dateFormatterWithFormat:(nonnull NSString *)formatString;
{
    NSDateFormatter *formatter = self.formatters[formatString];
    
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocalizedDateFormatFromTemplate:formatString];
        self.formatters[formatString] = formatter;
    }
    
    return formatter;
}

// MARK: - Cell Font

- (UIFont *)cellFont
{
    if(!_cellFont)
    {
        _cellFont = [UIFont boldSystemFontOfSize:13.0];
    }
    
    return _cellFont;
}

@end
