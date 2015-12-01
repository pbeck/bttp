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
    
    var screenshot:UIImage?
        
    /*
    {
        get {
            return self.screenshot
        }
        set {
            self.screenshot = newValue
        }
    }
    */
    var screenshotSize: CGSize {
        get {
            return CGSizeMake(self.screenshot!.size.width, self.screenshot!.size.height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // For debugging
        // self.backgroundColor = UIColor.greenColor()
        /*
        self.label = UILabel.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.label!.font = UIFont.boldSystemFontOfSize(60)
        self.label!.textAlignment = NSTextAlignment.Center
        self.label!.textColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.label!)
        */
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addScreenshot() {
        screenshotView = UIImageView(image: self.screenshot)
        screenshotView!.contentMode = .ScaleAspectFit
        screenshotView!.opaque = true
        screenshotView!.backgroundColor = UIColor.clearColor()
        screenshotView!.bounds = self.bounds
        screenshotView!.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);
        self.contentView.addSubview(screenshotView!)
        
        /*
        let layer = screenshotView!.layer
        layer.shadowOffset = CGSizeMake(0,1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.6
        screenshotView?.clipsToBounds = false
*/
    }


    override func prepareForReuse() {
        // TODO: Clear shadow CALayer?
        super.prepareForReuse()
    }
    
    
    
}