//
//  CKCalendarGridView.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarCellConfiguration.h"
#import "CKCalendarGridViewDataSource.h"

/**
 The CKCalendarGridView manages the display of cells in the calendar view.
 */
@interface CKCalendarGridView : UICollectionView

// MARK: - Configuring Cell Display

/**
 The name of the class used for cells. Should be a UICollectionViewCell subclass.
 */
@property (strong, nonatomic, nonnull) Class cellClass;

/**
 *  A block used to configure the cell. This is called multiple times per layout pass.
 */
@property (strong, nonatomic) CKCalendarCellConfigurationBlock _Nullable cellConfigurationBlock;

/**
 *  The calendar data source provides information about
 */

@property (nonatomic, strong, nonnull) id<CKCalendarGridViewDataSource> gridDataSource;

@end
