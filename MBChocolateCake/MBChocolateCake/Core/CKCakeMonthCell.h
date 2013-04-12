//
//  CKCakeCalendarCell.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCakeMonthCellStates.h"

@interface CKCakeMonthCell : UIView

@property (nonatomic, assign) CKCakeMonthCellState state;
@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, strong) UIColor *normalBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

//  Overrides normalBackgroundColor and selectedBackgroundColor
@property (nonatomic, strong) UIColor *todayBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *todaySelectedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *todayShadowColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textSelectedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textShadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textSelectedShadowColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *dotColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedDotColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *cellBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedCellBorderColor UI_APPEARANCE_SELECTOR;

- (id)initWithSize:(CGSize)size;

-(void)prepareForReuse;

- (void)setSelected;
- (void)setDeselected;

@end
