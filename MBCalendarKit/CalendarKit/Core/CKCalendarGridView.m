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
#import "NSDateComponents+AllComponents.h"

@interface CKCalendarGridView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

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

- (void)_registerDefaultCells
{
    self.cellClass = CKCalendarCell.class;
}

// MARK: - Configuring the Collection View

- (void)_configure
{
    [self _registerDefaultCells];

    self.delegate = self;
    self.dataSource = self;
}

// MARK: - Setting the Cell Class

- (void)setCellClass:(Class)cellClass
{
    if(self.class == cellClass)
    {
        return;
    }
    
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    _cellClass = cellClass;
}

// MARK: - Date Scrubbing

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint point = [touch locationInView:self];
    
    /* Highlight the cell under the touch. */
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    UICollectionViewCell *selectedCell = [self cellForItemAtIndexPath:indexPath];
    
    for(UICollectionViewCell *cell in self.visibleCells)
    {
        BOOL userIsTouchingCell = [cell isEqual:selectedCell];
        
        cell.highlighted = userIsTouchingCell;
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint point = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    UICollectionViewCell *selectedCell = [self cellForItemAtIndexPath:indexPath];
    
    for(UICollectionViewCell *cell in self.visibleCells)
    {
        BOOL userIsTouchingCell = [cell isEqual:selectedCell];
        
        if(userIsTouchingCell)
        {
            self.date = [self dateForIndexPath:indexPath];
            [self reloadData];
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self reloadData];
    [super touchesCancelled:touches withEvent:event];
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length;
    
    return itemCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionCount = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self.date].length;
    
    return sectionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    
    self.cellConfigurationBlock(cell, [self dateForIndexPath:indexPath]);
    
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
    NSUInteger numberOfDaysPerWeek = [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length;
    CGFloat width = CGRectGetWidth(self.superview.bounds);
    CGFloat margin = (CGFloat)((NSInteger)width % numberOfDaysPerWeek);
    CGFloat inset = margin / 2.0;
    
    return UIEdgeInsetsMake(0, inset, 0, inset);
}

// MARK: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfDaysPerWeek = [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length;
    
    if (numberOfDaysPerWeek == 0)
    {
        return CGSizeZero;
    }
    
    CGFloat width = CGRectGetWidth(self.superview.bounds);
    CGFloat widthAdjustForEvenDivisionByDaysPerWeek = width - (CGFloat)((NSInteger)width % numberOfDaysPerWeek);
    CGFloat side = widthAdjustForEvenDivisionByDaysPerWeek / (CGFloat)numberOfDaysPerWeek;
    
    CGFloat extra = width - widthAdjustForEvenDivisionByDaysPerWeek;
    
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

// MARK: - Changing the Date

- (void)setDate:(NSDate *)date
{
    [self reloadData];
    
    _date = date;
}

// MARK: -

- (void)adjustSectionCountToTransitionFrom:(NSDate *)oldDate to:(NSDate *)newDate
{
    NSInteger oldWeekCount = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:oldDate].length;
    NSInteger newWeekCount = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:newDate].length;
    
    if (oldWeekCount > newWeekCount)
    {
        while (self.visibleIndexSets.count > newWeekCount)
        {
            [self deleteSections:self.lastVisibleIndexSet];
        }
    }
    else
    {
        while (self.visibleIndexSets.count < newWeekCount)
        {
            [self insertSections:self.lastVisibleIndexSet];
        }
    }
    
}

// MARK: - Calculating Visible Index Sets

- (nullable NSArray <NSIndexSet *> *)visibleIndexSets
{
    NSArray <NSIndexPath *> * visibleIndexPaths = self.indexPathsForVisibleItems;
    NSMutableSet <NSIndexSet *> *indexSets = [[NSMutableSet alloc] init];
    
    for (NSIndexPath *indexPath in visibleIndexPaths)
    {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [indexSets addObject:indexSet];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstIndex" ascending:YES];
    NSArray *sortedIndexSets = [indexSets sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return sortedIndexSets;
}

- (nullable NSIndexSet *)lastVisibleIndexSet
{
    return self.visibleIndexSets.lastObject;
}

@end
