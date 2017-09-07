//
//  CKCalendarCellContextCache.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;
@class CKCalendarModel;
@class CKCalendarCellContext;

/**
 The CKCalendarCellContextCache is a private class which
 tracks the context of all of the cells being displayed.
 
 It keeps a strong reference to an NSCalendar provided by 
 the viewModel, as well as references to CKCalendarCellContext 
 objects, which are vended through the view model.
 
 When the CKCalendarModel changes, it informs its CKCalendarCellContextCache
 which in turn updates the context objects as necessary.
 */
NS_SWIFT_NAME(CalendarCellContextCache)
@interface CKCalendarCellContextCache : NSObject

// MARK: - Initializing a Cache

/**
 Initializes the context cache.
 
 @param model The calendar model to use for computing state cache.
 @return A cell context cache.
 */
- (nonnull instancetype)initWithCalendarModel:(nonnull CKCalendarModel *)model;

/**
 Looks up a context object by date.

 @param date The date to look up.
 @return A calendar cell context if it exists.
 */
- (nullable CKCalendarCellContext *)contextForDate:(nonnull NSDate *)date;

// MARK: - Purging the Cache

/**
 Empties the cache. This is called in response to `UIApplicationSignificantTimeChangeNotification`.
 */
- (void)purge;

// MARK: - Handling State Modifying Changes

// MARK: - Handling Selected Date Change

/**
 Called when the calendar's visible date changes.
 
 @param date The new visible date.
 */
- (void)handleChangeSelectedDateToDate:(nonnull NSDate *)date;

@end
