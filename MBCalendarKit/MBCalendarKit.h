//
//  MBCalendarKit.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 7/31/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;

//! Project version number for MBCalendarKit.
FOUNDATION_EXPORT double MBCalendarKitVersionNumber;

//! Project version string for MBCalendarKit.
FOUNDATION_EXPORT const unsigned char MBCalendarKitVersionString[];

// MARK: - Core Library

/* The Calendar View */
#import <MBCalendarKit/CKCalendarView.h>

/* Custom Cells */
#import <MBCalendarKit/CKCalendarView+CustomCells.h>
#import <MBCalendarKit/CKCustomCellProviding.h>
#import <MBCalendarKit/CKCalendarCellContext.h>
#import <MBCalendarKit/CKCalendarView+DefaultCellProviderImplementation.h>

/* Default Calendar Cell Implementation */
#import <MBCalendarKit/CKCalendarCell.h>  // Subclass this to modify the default cell.
#import <MBCalendarKit/CKCalendarCellColors.h>

/* Calendar View Controller */
#import <MBCalendarKit/CKCalendarViewController.h>
#import <MBCalendarKit/CKTableViewCell.h>

/* Event Data Source & Delegate */
#import <MBCalendarKit/CKCalendarEvent.h>
#import <MBCalendarKit/CKCalendarDataSource.h>
#import <MBCalendarKit/CKCalendarDelegate.h>

/* Calendar Header View (For Appearance) */
#import <MBCalendarKit/CKCalendarHeaderView.h>
#import <MBCalendarKit/CKCalendarHeaderViewDataSource.h>
#import <MBCalendarKit/CKCalendarHeaderViewDelegate.h>
#import <MBCalendarKit/CKCalendarHeaderColors.h>
#import <MBCalendarKit/MBPolygonView.h>

// MARK: - Foundation Categories

#import <MBCalendarKit/NSCalendarCategories.h>
#import <MBCalendarKit/NSDate+Components.h>
#import <MBCalendarKit/NSDate+Description.h>
#import <MBCalendarKit/NSDateComponents+AllComponents.h>
