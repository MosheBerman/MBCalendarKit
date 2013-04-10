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

@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *todayBackgroundColor;        //  Overrides normalBackgroundColor
    
@end
