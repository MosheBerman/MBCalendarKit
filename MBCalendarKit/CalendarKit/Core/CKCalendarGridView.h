//
//  CKCalendarGridView.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarGridViewDataSource.h"
#import "CKCalendarGridViewDelegate.h"

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
 The grid appearance delegate is responsible for configuring cells for display, based on the parameters passed into it.
 */
@property (nonatomic, weak, nullable) id<CKCalendarGridViewDelegate> gridAppearanceDelegate;

// MARK: - Configuring How Much Data To Show

/**
 *  The calendar data source provides information about how many rows and columns need to be displayed.
 */
@property (nonatomic, weak, nullable) id<CKCalendarGridViewDataSource> gridDataSource;




@end
