//
//  CKCalendarCellBase.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarCellState.h"

NS_SWIFT_NAME(CalendarCellBase)
@interface CKCalendarCellBase : UICollectionViewCell

// MARK: - Cell State and Touch Tracking

/**
 The state of the cell.
 */
@property (nonatomic, assign) CKCalendarCellState state;

// MARK: - Initializers

- (instancetype)init NS_DESIGNATED_INITIALIZER;

// MARK: - Managing Cell State

/**
 Marks the cell as selected.
 */
- (void)setSelected;

/**
 Mark the cell as deselected.
 */
- (void)setDeselected;

/**
 Mark the cell as out of range, useful when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;

@end
