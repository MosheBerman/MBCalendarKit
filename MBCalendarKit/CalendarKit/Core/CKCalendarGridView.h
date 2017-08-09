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

/**
 The NSCalendar which acts as a model for the calendar view.
 */
@property (nonatomic, strong, nonnull) NSCalendar *calendar;


/**
 The active date.
 */
@property (nonatomic, strong, nonnull) NSDate *date;


/**
 The name of the class used for cells. Should be a UICollectionViewCell subclass.
 */
@property (strong, nonatomic, nonnull) Class cellClass;

/**
 *
 */
@property (strong, nonatomic) CKCalendarCellConfigurationBlock _Nullable cellConfigurationBlock;

@end
