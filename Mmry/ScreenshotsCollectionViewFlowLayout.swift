//
//  ScreenshotsCollectionViewFlowLayout.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-11-29.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var dynamicAnimator:UIDynamicAnimator?
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        //self.itemSize = CGSizeMake(400, 520);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // http://stackoverflow.com/questions/13228600/uicollectionview-align-logic-missing-in-horizontal-paging-scrollview
    /*
    override func collectionViewContentSize() -> CGSize {
        // Only support single section for now.
        // Only support Horizontal scroll
        let count = 10
        
        let canvasSize = self.collectionView!.frame.size
        var contentSize = canvasSize
        //if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            let rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1
            let columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1
            let page = ceilf(Float(count) / Float(rowCount * columnCount))
            contentSize.width = CGFloat(CGFloat(page) * canvasSize.width)
        //}
        
        return contentSize;
    }
*/
    
    /*
    override init() {
        super.init()
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 40;
        self.itemSize = CGSizeMake(400, 520);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        /*
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [NSMutableSet set];
        self.isEnabled = YES;
*/
    }
*/
    
    /*
    override func prepareLayout() {
        super.prepareLayout()
        
        let visibleRect = CGRectInset(CGRect(origin: self.collectionView!.bounds.origin, size: self.collectionView!.frame.size), -1000, -1000)
        var itemsInVisibleRectArray = super.layoutAttributesForElementsInRect(visibleRect)
       
        var itemsIndexPathsInVisibleRectSet //= NSSet.   [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
        
        let *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
        }]];
        
        [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
        }];
        
        NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
        }]];
        
        CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
        
        [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 0.8f;
        springBehaviour.frequency = 2.f;
        
        [self updateItemInSpringBehavior:springBehaviour withTouchLocation:touchLocation];
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
        }];
        
    }
    */
}