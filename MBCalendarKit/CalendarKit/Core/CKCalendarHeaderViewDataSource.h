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

@protocol CKCalendarHeaderViewDataSource <NSObject>

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header;

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header;
- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index;

- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header;
- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header;
- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header;

@end

#endif /* CKCalendarHeaderViewDataSource_h */
