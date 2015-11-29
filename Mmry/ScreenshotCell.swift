//
//  ScreenshotCell.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-11-29.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotCell: UICollectionViewCell {
    public var label:UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label = UILabel.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.label!.font = UIFont.boldSystemFontOfSize(60)
        self.label!.textColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.label!)
        /*
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.font = [UIFont boldSystemFontOfSize:60.f];
        self.label.textColor = [UIColor colorWithRed:243.f/255.f green:118.f/255.f blue:6.f/255.f alpha:1];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:245.f/255.f green:239.f/255.f blue:213.f/255.f alpha:1.f];
        [self.contentView addSubview:self.label];
        */
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}