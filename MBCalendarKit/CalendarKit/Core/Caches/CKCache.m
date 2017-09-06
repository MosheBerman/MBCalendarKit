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
 The date formatter is actually nullable.
 */
@property (nonatomic, strong, nullable) NSDateFormatter *dateFormatter;

/**
 A cache for the cell contexts.
 */
@property (nonatomic, strong, nonnull) CKContextCache *cellContexts;

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
        
    }
    return self;
}

// MARK: - Responding to Memory Pressure

- (void)purge
{
    _dateFormatter = nil;
    [self.cellContexts purge];
}

// MARK: - NSDateFormatter Caching

/**
 Returns the date formatter. If one does not exist, creates it.

 @return The cached date formatter.
 */
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

// MARK: - CKCalendarCellContext Caching

- (CKContextCache *)cellContexts
{
    if(!_cellContexts)
    {
        _cellContexts = [[CKContextCache alloc] init];
    }
    
    return _cellContexts;
}

@end
