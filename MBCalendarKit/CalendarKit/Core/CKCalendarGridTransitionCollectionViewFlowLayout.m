//
//  CKCalendarGridTransitionCollectionViewFlowLayout.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarGridTransitionCollectionViewFlowLayout.h"

@implementation CKCalendarGridTransitionCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transitionDirection = CKCalendarTransitionDirectionForward;
        _transitionAxis = CKCalendarGridTransitionAxisVertical;
        _differenceInSectionCountAfterUpdates = 0;
        
        self.collectionView.viewForBaselineLayout.layer.duration = 0.4;
    }
    return self;
}

// MARK: - Animating

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
{
    
    [super prepareForCollectionViewUpdates:updateItems];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    CGRect frame = attr.frame;
    
    if (self.transitionAxis == CKCalendarGridTransitionAxisVertical)
    {
        frame.origin.y += -self.initialOffset;
    }
    else
    {
        frame.origin.x += -self.initialOffset;
    }
    
    attr.frame = frame;
    attr.alpha = 1.0;
    
    return attr;
}


- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    CGRect frame = attr.frame;
    
    if (self.transitionAxis == CKCalendarGridTransitionAxisVertical)
    {
        frame.origin.y += self.initialOffset;
    }
    else
    {
        frame.origin.x += self.initialOffset;
    }
    attr.frame = frame;
    attr.alpha = 1.0;
    
    return attr;
}

// MARK: -

- (NSInteger)initialOffset
{
    CGSize bounds = self.collectionView.contentSize;
    
    CGFloat distance = 0.0;
    
    if (self.transitionAxis == CKCalendarGridTransitionAxisVertical)
    {
        distance = bounds.height;
    }
    else /* Horizontal */
    {
        distance = bounds.width;
    }
    
    if (self.transitionDirection == CKCalendarTransitionDirectionForward)
    {
        distance = -distance;
    }
    
    return distance;
}

@end
