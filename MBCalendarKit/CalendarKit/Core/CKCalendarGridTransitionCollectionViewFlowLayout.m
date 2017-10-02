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
    }
    return self;
}

// MARK: - Animating

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    CGRect frame = attr.frame;
    
    if (self.transitionAxis == CKCalendarGridTransitionAxisVertical)
    {
        frame.origin.y -= self.initialOffset.y;
    }
    else
    {
        frame.origin.x -= self.initialOffset.x;
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
        frame.origin.y += self.initialOffset.y;
    }
    else
    {
        frame.origin.x += self.initialOffset.x;
    }
    
    attr.frame = frame;
    attr.alpha = 1.0;
    
    return attr;
}

@end
