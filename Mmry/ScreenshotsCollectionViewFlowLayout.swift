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
        self.minimumInteritemSpacing = 10000
        self.itemSize = CGSizeMake(200, 600)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
}