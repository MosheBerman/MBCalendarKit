//
//  CKContextCache.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKContextCache.h"
@import UIKit;

@interface CKContextCache ()

/**
 A cache for the context objects.
 */
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, CKCalendarCellContext *> *cache;

@end

@implementation CKContextCache

// MARK: - Initializers

- (instancetype)init
{
    self = [self initWithCalendar:NSCalendar.autoupdatingCurrentCalendar];
    if (self) {
        
    }
    return self;
}


/**
 Initializes the context cache.

 @param calendar The calendar to cache against.
 @return A cell context cache.
 */
- (instancetype)initWithCalendar:(NSCalendar *)calendar
{
    self = [super init];
    if (self) {
        _calendar = calendar;
        _cache = [[NSMutableDictionary alloc] init];
        
        [self observeSignificantTimeChanges];
    }
    return self;
}

// MARK: - Caching Items

/**
 Add a context object to the cache.
 
 @param context The context object to cache.
 @param date The date to cache it for.
 */
- (void)addContext:(CKCalendarCellContext *)context forDate:(NSDate *)date;
{
    NSString *key = [self keyForDate:date];
    self.cache[key] = context;
}

/**
 Looks up a context object by date.
 
 @param date The date to look up.
 @return A calendar cell context if it exists.
 */
- (nullable CKCalendarCellContext *)contextForDate:(NSDate *)date;
{
    NSString *key = [self keyForDate:date];
    
    return self.cache[key];
}

// MARK: - Creating a Key

- (nullable NSString *)keyForDate:(nonnull NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components = [self.calendar components:units fromDate:date];
    
    return [NSString stringWithFormat:@"%li-%li-%li", (long)components.year, (long)components.month, (long)components.day];
}

// MARK: - Calendar

- (void)setCalendar:(NSCalendar *)calendar
{
    _calendar = calendar;
    [self purge];
}

// MARK: - Observe Significant Date Changes

/**
 Register to handle significant time changes.
 */
- (void)observeSignificantTimeChanges
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleSignificantTimeChange) name:UIApplicationSignificantTimeChangeNotification object:nil];
}

/**
 When there's a significant time change, we want to handle it.
 Simplistic approach is to dump the cache.
 A smarter approach might be to update the cached items to determine the day.
 */
- (void)handleSignificantTimeChange
{
    [self purge];
}

// MARK: - Purging the Cache

- (void)purge
{
    [self.cache removeAllObjects];
}

@end
