//
//  CKContextCache.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;
@class CKCalendarCellContext;

@interface CKContextCache : NSObject

// MARK: - Initializing a Cache

/**
 Initializes the context cache.
 
 @param calendar The calendar to cache against.
 @return A cell context cache.
 */
- (nonnull instancetype)initWithCalendar:(nonnull NSCalendar *)calendar;

// MARK: -

/**
 The calendar that the cache works against.
 */
@property (nonatomic, strong, nonnull) NSCalendar *calendar;

/**
 Add a context object to the cache.

 @param context The context object to cache.
 @param date The date to cache it for.
 */
- (void)addContext:(nonnull CKCalendarCellContext *)context forDate:(nonnull NSDate *)date;

/**
 Looks up a context object by date.

 @param date The date to look up.
 @return A calendar cell context if it exists.
 */
- (nullable CKCalendarCellContext *)contextForDate:(nonnull NSDate *)date;

// MARK: - Purging the Cache

/**
 Empties the cache.
 */
- (void)purge;

@end
