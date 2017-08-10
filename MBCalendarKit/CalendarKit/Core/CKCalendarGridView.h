//
//  CKCalendarGridView.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;
#import "CKCalendarCellConfiguration.h"

/**
 The CKCalendarGridView manages the display of cells in the calendar view.
 */
@interface CKCalendarGridView : UICollectionView

// MARK: - The Calendar

/**
 The NSCalendar which acts as a model for the calendar view.
 */
@property (nonatomic, strong, nonnull) NSCalendar *calendar;

// MARK: - Selected Date

/**
 The active date.
 */
@property (nonatomic, strong, nonnull) NSDate *date;

// MARK: - Configuring Cell Display

/**
 The name of the class used for cells. Should be a UICollectionViewCell subclass.
 */
@property (strong, nonatomic, nonnull) Class cellClass;

/**
 *  A block used to configure the cell. This is called multiple times per layout pass.
 */
@property (strong, nonatomic) CKCalendarCellConfigurationBlock _Nullable cellConfigurationBlock;

@end
