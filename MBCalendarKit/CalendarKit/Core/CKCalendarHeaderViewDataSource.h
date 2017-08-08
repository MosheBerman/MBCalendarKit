//
//  CKCalendarHeaderViewDataSource.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCalendarHeaderViewDataSource_h
#define CKCalendarHeaderViewDataSource_h

@class CKCalendarHeaderView;


/**
 The CKCalendarHeaderViewDataSource provides dsplay information for the calendar's header view.
 
 @discussion A CKCalendarHeaderView consults its data source whenever its `reloadData` method is called.
 */
@protocol CKCalendarHeaderViewDataSource <NSObject>


// MARK: - The Month/Day Title

/**
 The title to display in the large label of the header view. 
 
 @discussion This may be the localized name of the month for the month display mode, or the name of the date for day mode.

 @param header The header view requesting the information.
 @return A string to display in the header.
 */
- (NSString *)titleForHeader:(CKCalendarHeaderView *)header;

/**
 Determines whether the header view should highlight its title label with its `headerTitleHighlightedTextColor` property.
 
 @discussion On iOS versions prior to 7, the native calendar app highlighted the title when the current date was visible in day mode. 
 
 If NO, `headerMonthTextColor` is used instead.

 @param header The header view requesting the information.
 @return YES if the header view should highlight.
 */
- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header;


// MARK: - Providing the Weekday Counts and Titles

/**
 The number of columns to display in the header.

 @param header the header view requesting the information.
 @return A number of columns, usually based on the length of the calendar's week, in days. (So pretty much "7" on any platform.)
 */
- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header;

/**
 The title to display in the header view's month label.

 @param header The header view requesting the information.
 @param index A zero-based index for the title. (For a Gregorian calendar, it may be appropriate to return a localized variant of "Sun" for index 0, etc.)
 @return A string to use as the column's title.
 */
- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index;

// MARK: - Disabling the Forward and Backward Buttons

/**
 Determines if the header view should ignore taps on the forward button.
 
 @discussion Used for implementing `CKCalendarView`'s `maximumDate` property, based on the calendar view's state.

 @param header The header view requesting the information.
 @return YES if the button should be enabled.
 */
- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header;


/**
 Determines if the header view should ignore taps on the backward button.
 
 @discussion Used for implementing `CKCalendarView`'s `minimumDate` property, based on the calendar view's state.
 
 @param header The header view requesting the information.
 @return YES if the button should be enabled.
 */
- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header;

@end

#endif /* CKCalendarHeaderViewDataSource_h */
