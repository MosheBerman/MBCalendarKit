//
//  CKCakeHeaderView.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeHeaderView.h"

#import "UIView+Border.h"

#import "CKCakeHeaderColors.h"

@interface CKCakeHeaderView ()
{
    NSUInteger _columnCount;
}

@property (nonatomic, strong) UILabel *monthTitle;
@property (nonatomic, strong) NSMutableArray *columnTitles;
@property (nonatomic, strong) NSMutableArray *columnLabels;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *backwardButton;

@end

@implementation CKCakeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _monthTitle = [UILabel new];
        [_monthTitle setTextColor:kCakeColorHeaderMonth];
        [_monthTitle setShadowColor:kCakeColorHeaderMonthShadow];
        [_monthTitle setShadowOffset:CGSizeMake(0, 1)];
        [_monthTitle setBackgroundColor:[UIColor clearColor]];
        [_monthTitle setTextAlignment:NSTextAlignmentCenter];
        [_monthTitle setFont:[UIFont boldSystemFontOfSize:22]];
        
        _columnTitles = [NSMutableArray new];
        _columnLabels = [NSMutableArray new];

        _forwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _backwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reload];
    [self layoutSubviews];
    [super willMoveToSuperview:newSuperview];
    [self setBackgroundColor:kCakeColorHeaderGradientDark];
}

- (void)layoutSubviews
{
    
    /* Remove old labels if they exist */
    for (UILabel *l in [self columnLabels]) {
        [l removeFromSuperview];
    }
    
    [[self columnLabels] removeAllObjects];
    
    /* Convert title strings into labels and lay them out */
    
    CGFloat labelWidth = [self frame].size.width/_columnCount;
    CGFloat labelHeight = 15;
    
    for (NSUInteger i = 0; i < [[self columnTitles] count]; i++) {
        NSString *title = [self columnTitles][i];

        UILabel *label = [self _columnLabelWithTitle:title];
        [[self columnLabels] addObject:label];
        
        CGRect frame = CGRectMake(i*labelWidth, [self frame].size.height-labelHeight, labelWidth, labelHeight);
        [label setFrame:frame];
        
        [self addSubview:label];
    }
    
    /* Show the title Label */
    CGRect frame = CGRectMake(5, 0, [self frame].size.width, 27);
    [[self monthTitle] setFrame:frame];
    [self addSubview:[self monthTitle]];
    
    /* Show the forward and back buttons */
    
}

#pragma mark - Convenience Methods

- (UILabel *)_columnLabelWithTitle:(NSString *)title
{
    UILabel *l = [UILabel new];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:kCakeColorHeaderWeekdayTitle];
    [l setShadowColor:kCakeColorHeaderWeekdayShadow];    
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setFont:[UIFont boldSystemFontOfSize:10]];
    [l setShadowOffset:CGSizeMake(0, 1)];
    [l setText:title];
    
    return l;
}

- (void)reload
{
    /*  STEP 1: Require a data source for the header to be installed */
    if (![self dataSource]) {
        @throw [NSException exceptionWithName:@"CKCakeViewHeaderException" reason:@"Header can't be installed without a data source" userInfo:@{@"Header": self}];
    }
    
    /* STEP 2: Now query the data source for the number of columns. */
    _columnCount = [[self dataSource] numberOfColumnsForHeader:self];
    
    /* STEP 3:  Query the datasource for the titles.*/
    [[self columnTitles] removeAllObjects];
    
    for (NSUInteger column = 0; column < _columnCount; column++) {
        NSString *title = [[self dataSource] titleForColumnAtIndex:column inHeader:self];
        [[self columnTitles] addObject:title];
    }
    
    /* STEP 4: Month Name */
    NSString *title = [[self dataSource] titleForHeader:self];
    [[self monthTitle] setText:title];
}

#pragma mark - Button Handling

- (void)forwardButtonTapped
{
    if ([[self delegate] respondsToSelector:@selector(forwardTapped)]) {
        [[self delegate] forwardTapped];
    }
}

- (void)backwardButtonTapped
{
    if ([[self delegate] respondsToSelector:@selector(backwardTapped)]) {
        [[self delegate] backwardTapped];
    }
}

@end
