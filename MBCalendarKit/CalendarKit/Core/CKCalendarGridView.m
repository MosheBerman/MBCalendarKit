//
//  CKCalendarGridView.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarGridView.h"
#import "NSCalendarCategories.h"

#import "CKCalendarCell.h"

@interface CKCalendarGridView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonnull, copy, nonatomic) NSString *reuseIdentifier;

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
    if(self.cellClass == cellClass)
    {
        return;
    }
    
    if(!cellClass)
    {
        [self _registerDefaultCells];
        return;
    }
    
    self.reuseIdentifier = NSStringFromClass(cellClass);
    [self registerClass:cellClass forCellWithReuseIdentifier:self.reuseIdentifier];
    _cellClass = cellClass;
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gridDataSource.numberOfColumns;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionCount = self.gridDataSource.numberOfRows;
    
    return sectionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
}

// MARK: - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.gridAppearanceDelegate respondsToSelector:@selector(calendarGrid:willDisplayCell:forDate:)])
    {
        NSDate *date = [self.gridDataSource dateForIndexPath:indexPath];
        [self.gridAppearanceDelegate calendarGrid:self willDisplayCell:(id)cell forDate:date];
    }
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
    
    CGFloat extraPixel = [self numberOfPixelsToAddToWidthAtIndexPath:indexPath];
    
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

// MARK: - Compensating for Extra Pixels When Adjusting for Precise Divisibility


/**
 Determines if a given column needs an extra pixel to fill the width of the parent view.
 
 @param indexPath The indexPath of the cell.
 @return A pixel count, which is how many pixels to add to the width of the item.
 */
- (CGFloat)numberOfPixelsToAddToWidthAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat pixelCount = 0.0;
    NSInteger item = indexPath.row;
    
    NSUInteger numberOfDaysPerWeek = self.gridDataSource.numberOfColumns;
    
    if (numberOfDaysPerWeek == 0)
    {
        return 0.0;
    }
    
    CGFloat width = CGRectGetWidth(self.superview.bounds);
    CGFloat widthAdjustForEvenDivisionByDaysPerWeek = width - (CGFloat)((NSInteger)width % numberOfDaysPerWeek);
    CGFloat extra = width - widthAdjustForEvenDivisionByDaysPerWeek;
    
    BOOL itemIndexHasParityWithExtraPixelCount = (item % 2 == (NSInteger)extra % 2);
    BOOL itemIsIsAssignedAPixelInAlternatingColumnSituation = extra - (item/2.0) > 0  && itemIndexHasParityWithExtraPixelCount;
    /*
     One pixel less than the number of columns, apply to all but the last one.
     i.e. 6 pixels with a 7 day week.
     */
    if (extra == numberOfDaysPerWeek - 1)
    {
        if (item < numberOfDaysPerWeek - 2)
        {
            pixelCount = 1.0;
        }
    }
    /*
     Two pixels less than the number of columns, apply extra to all but first & last.
     i.e. 5 pixels with a 7 day week.
     */
    else if (extra == numberOfDaysPerWeek - 2)
    {
        if (item != 0 && item < numberOfDaysPerWeek - 2) {
            pixelCount = 1.0;
        }
    }
    
    /*
     An even number of pixels that is three or more fewer than the number of columns.
     i.e. 4 pixels in a 7 day week.
     */
    else if ((NSInteger)extra % 2 == 0)
    {
        if (itemIsIsAssignedAPixelInAlternatingColumnSituation)
        {
            pixelCount = 1.0;
        }
    }
    /* Odd number of extra pixels, less than one less than the number of columns. */
    else if (item % 2 == 1 && itemIsIsAssignedAPixelInAlternatingColumnSituation)
    {
        pixelCount = 1.0;
    }
    
    return pixelCount;
}

@end
