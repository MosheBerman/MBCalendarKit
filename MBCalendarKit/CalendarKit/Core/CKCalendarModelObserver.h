//
//  CKCalendarModelObserver.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

@class CKCalendarModel;

/**
 This protocol defines an interface for the calendar view to internally monitor the `CKCalendarModel`.
 */
@protocol CKCalendarModelObserver <NSObject>

// MARK: - Handling Date Changes
/**
 Called before the calendar model will change the its date.

 @param model The model object that will change.
 */
- (void)modelWillChangeDate:(CKCalendarModel *)model;

/**
 Called after the model will change the its date.

 @param model The model object that was changed.
 */
- (void)modelDidChangeDate:(CKCalendarModel *)model;

@end
