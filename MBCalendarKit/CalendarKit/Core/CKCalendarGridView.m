//
//  CKCalendarGridView.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarGridView.h"
#import "CKCalendarCell.h"
#import "NSCalendarCategories.h"

@interface CKCalendarGridView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation CKCalendarGridView

// MARK: - Initializers

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self _configure];
    }
    return self;
}

// MARK: - Configuring the Collection View

- (void)_configure
{
    [self _registerDefaultCells];
    self.dataSource = self;
    self.delegate = self;
}

- (void)_registerDefaultCells
{
    self.cellClass = CKCalendarCell.class;
}

// MARK: - Autolayout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// MARK: - Setting the Cell Class

- (void)setCellClass:(nonnull Class)cellClass
{
    if(self.class == cellClass)
    {
        return;
    }
    
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    _cellClass = cellClass;
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = self.gridDataSource.numberOfColumns;
    
    return itemCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionCount = self.gridDataSource.numberOfRows;
    
    return sectionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    
    if ([self.gridAppearanceDelegate respondsToSelector:@selector(calendarGrid:willDisplayCell:forDate:)])
    {
        NSDate *date = [self.gridDataSource dateForIndexPath:indexPath];
        [self.gridAppearanceDelegate calendarGrid:self willDisplayCell:cell forDate:date];
    }
    
    return cell;
}

// MARK: - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.borderColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5].CGColor;
    cell.layer.borderWidth = 0.5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSUInteger numberOfDaysPerWeek = self.gridDataSource.numberOfColumns;
    CGFloat width = CGRectGetWidth(self.superview.bounds);
    CGFloat margin = (CGFloat)((NSInteger)width % numberOfDaysPerWeek);
    CGFloat inset = margin / 2.0;
    
    return UIEdgeInsetsMake(0, inset, 0, inset);
}

// MARK: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfDaysPerWeek = self.gridDataSource.numberOfColumns;
    
    if (numberOfDaysPerWeek == 0)
    {
        return CGSizeZero;
    }
    
    CGFloat width = CGRectGetWidth(self.superview.bounds);
    CGFloat widthAdjustForEvenDivisionByDaysPerWeek = width - (CGFloat)((NSInteger)width % numberOfDaysPerWeek);
    CGFloat side = widthAdjustForEvenDivisionByDaysPerWeek / (CGFloat)numberOfDaysPerWeek;
    
//    CGFloat extra = width - widthAdjustForEvenDivisionByDaysPerWeek;
    
    CGFloat extraPixel = 0;
    
    return CGSizeMake(side + extraPixel, side);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0.0;
}

@end
