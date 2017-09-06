//
//  CKCalendarCellContextCache.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellContextCache.h"
#import "CKCalendarCellContext.h"
#import "CKCache.h"

@import UIKit;

@interface CKCalendarCellContextCache ()

// MARK: - The Calendar View

/**
 The calendar view.
 */
@property (nonatomic, nullable, weak) CKCalendarView *calendarView;

// MARK: - The Cache

/**
 A cache for the context objects.
 */
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, CKCalendarCellContext *> *cache;

// MARK: - Caching Today and Selection

@end

@implementation CKCalendarCellContextCache

/**
 Initializes the context cache.
 
 @param calendarView The calendar view to cache for.
 @return A cell context cache.
 */
- (nonnull instancetype)initWithCalendarView:(nonnull CKCalendarView *)calendarView;
{
    self = [super init];
    if(self)
    {
        _calendarView = calendarView;
        [self observeLowMemoryNotification];
        [self observeSignificantTimeChanges];
    }
    
    return self;
}

// MARK: - Accessing the Cache

/**
 Looks up a context object by date.
 
 @param date The date to look up.
 @return A calendar cell context if it exists.
 */
- (nullable CKCalendarCellContext *)contextForDate:(NSDate *)date;
{
    NSString *key = [self keyForDate:date];
    
    CKCalendarCellContext *context = self.cache[key];
    
    if(!context)
    {
        context = [[CKCalendarCellContext alloc] initWithDate:date andCalendarView:self.calendarView];
        self.cache[key] = context;
    }
    
    return context;
}

// MARK: - Creating a Key

- (nullable NSString *)keyForDate:(nonnull NSDate *)date
{
    [CKCache.sharedCache.dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *key = [CKCache.sharedCache.dateFormatter stringFromDate:date];
    
    return key;
}

// MARK: - Handle

// MARK: - Handle Changes to NSDate.date

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

// MARK: - Handle Low Memory Conditions

- (void)observeLowMemoryNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purge) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

// MARK: - Purging the Cache

- (void)purge
{
    [self.cache removeAllObjects];
}

@end
