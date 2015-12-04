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
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.minimumInteritemSpacing = 200;
        self.minimumLineSpacing = 0;
        //self.itemSize = CGSizeMake(400, 520);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollDirection = .Horizontal

    }
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
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
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = MAXFLOAT
        let horizontalOffset:Float = Float(proposedContentOffset.x) + 5.0
        
        let targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
        let array = super.layoutAttributesForElementsInRect(targetRect)
        for layoutAttributes in array! {
            let itemOffset:Float = Float(layoutAttributes.frame.origin.x)
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        return CGPointMake(proposedContentOffset.x + CGFloat(offsetAdjustment), proposedContentOffset.y)
        
    }
    */
    
    // https://gist.github.com/mmick66/9812223
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        //For this to work paging must be disabled if not the return value will be overriden down the line by the scroll view
        if (self.collectionView!.pagingEnabled) {
            return proposedContentOffset;
        }
        
        //let collectionViewSize: CGSize = self.collectionView!.bounds.size
        let rectBounds: CGRect = self.collectionView!.bounds
        let halfWidth: CGFloat = rectBounds.size.width * CGFloat(0.50)
        let proposedContentOffsetCenterX: CGFloat = proposedContentOffset.x + halfWidth
        
        let proposedRect: CGRect = self.collectionView!.bounds
        
        let attributesArray:NSArray = self.layoutAttributesForElementsInRect(proposedRect)!
        
        var candidateAttributes:UICollectionViewLayoutAttributes?
        
        
        for layoutAttributes : AnyObject in attributesArray {
            
            if let _layoutAttributes = layoutAttributes as? UICollectionViewLayoutAttributes {
                
                if _layoutAttributes.representedElementCategory != UICollectionElementCategory.Cell {
                    continue
                }
                
                if candidateAttributes == nil {
                    candidateAttributes = _layoutAttributes
                    continue
                }
                
                if fabsf(Float(_layoutAttributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(candidateAttributes!.center.x) - Float(proposedContentOffsetCenterX)) {
                    candidateAttributes = _layoutAttributes
                }
                
            }
        }
        
        if attributesArray.count == 0 {
            return CGPoint(x: proposedContentOffset.x - halfWidth * 2,y: proposedContentOffset.y)
        }
        
        return CGPoint(x: candidateAttributes!.center.x - halfWidth, y: proposedContentOffset.y)
    }
}