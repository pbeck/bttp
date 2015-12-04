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
    var label:UILabel?
    var screenshotView:UIView?
    var createReminderButton:UIButton?
    var screenshot:UIImage?
        
    var screenshotSize: CGSize {
        get {
            return CGSizeMake(self.screenshot!.size.width, self.screenshot!.size.height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        // For debugging
        // self.backgroundColor = UIColor.greenColor()
        
        /*
        self.label = UILabel.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.label!.font = UIFont.boldSystemFontOfSize(60)
        self.label!.textAlignment = NSTextAlignment.Center
        self.label!.textColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.label!)
        */
        
        //self.screenshotView.bounds = CGRectInset(self.frame, 10.0, 10.0);
    }
    
    func addScreenshot() {
        screenshotView = UIImageView(image: self.screenshot)
        screenshotView!.contentMode = .ScaleAspectFit
        screenshotView!.opaque = true
        screenshotView!.backgroundColor = UIColor.blueColor()
        screenshotView!.bounds = self.bounds
        screenshotView!.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);
        self.contentView.addSubview(screenshotView!)
        
        /*
        let layer = screenshotView!.layer
        layer.shadowOffset = CGSizeMake(0,1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 26
        layer.shadowOpacity = 0.2
        */
    }


    override func prepareForReuse() {
        // TODO: Clear shadow CALayer?
        super.prepareForReuse()
    }
    
    
    
}