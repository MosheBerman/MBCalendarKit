//
//  CKCalendarCellContextCache.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;
@class CKCalendarView;
@class CKCalendarCellContext;

@interface CKCalendarCellContextCache : NSObject

// MARK: - Initializing a Cache

/**
 Initializes the context cache.
 
 @param calendarView The calendar view to cache for.
 @return A cell context cache.
 */
- (nonnull instancetype)initWithCalendarView:(nonnull CKCalendarView *)calendarView;

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
