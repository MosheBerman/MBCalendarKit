//
//  CKCakeHeaderView.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKCakeHeaderView;

@protocol CKCakeHeaderViewDataSource <NSObject>

- (NSString *)titleForHeader:(CKCakeHeaderView *)header;

- (NSUInteger)numberOfColumnsForHeader:(CKCakeHeaderView *)header;
- (NSString *)header:(CKCakeHeaderView *)header titleForColumnAtIndex:(NSInteger)index;

@end

@protocol CKCakeHeaderViewDelegate <NSObject>

- (void)forwardTapped;
- (void)backwardTapped;

@end

@interface CKCakeHeaderView : UIView

@property (nonatomic, assign) id<CKCakeHeaderViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCakeHeaderViewDelegate> delegate;


@end
