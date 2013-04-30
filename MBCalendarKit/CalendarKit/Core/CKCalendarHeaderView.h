//
//  CKCalendarHeaderView.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKCalendarHeaderView;

@protocol CKCalendarHeaderViewDataSource <NSObject>

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header;

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header;
- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index;

- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header;
- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header;
- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header;

@end

@protocol CKCalendarHeaderViewDelegate <NSObject>

- (void)forwardTapped;
- (void)backwardTapped;

@end

@interface CKCalendarHeaderView : UIView

@property (nonatomic, assign) id<CKCalendarHeaderViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarHeaderViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIGestureRecognizer *tapGesture;


@end
