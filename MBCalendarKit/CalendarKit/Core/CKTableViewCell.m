//
//  CKTableViewCell.m
//  MBCalendarKit
//
//  Created by Rachel Hyman on 6/2/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "CKTableViewCell.h"

@implementation CKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //Moves cell text label over to make space for color square on left
    self.textLabel.frame = CGRectMake(35, 0, 260, 44);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
