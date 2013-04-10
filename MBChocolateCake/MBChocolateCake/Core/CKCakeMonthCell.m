//
//  CKCakeCalendarCell.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeMonthCell.h"
#import "CKCakeCellColors.h"

@interface CKCakeMonthCell ()

@end

@implementation CKCakeMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _state = CKCakeMonthCellStateNormal;
        _selectedBackgroundColor = kCakeColorBlue;
        _normalBackgroundColor = kCakeColorLightGray;
        _todayBackgroundColor = kCakeColorBlue;
    }
    return self;
}

-(void)layoutSubviews
{
    
}

@end
