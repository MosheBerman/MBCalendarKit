//
//  CKCalendarCellConfiguration.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/9/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//


#ifndef CKCalendarCellConfiguration_h
#define CKCalendarCellConfiguration_h

@class CKCalendarCell;


/**
 A block that allows the configuration of a collection view cell.

 @param cell A UICollectionViewCell that can be configured.
 */
typedef void(^CKCalendarCellConfigurationBlock)(UICollectionViewCell * _Nonnull cell, NSDate * _Nonnull date);

#endif /* CKCalendarCellConfiguration_h */
