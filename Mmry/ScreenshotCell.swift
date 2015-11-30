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
    var screenshot:UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.greenColor()
        
        self.label = UILabel.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.label!.font = UIFont.boldSystemFontOfSize(60)
        self.label!.textAlignment = NSTextAlignment.Center
        self.label!.textColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.label!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScreenshot() {
        self.screenshot = UIImage(named: "screenshot-sample-iphone6")
        let screenshotView = UIImageView(image: self.screenshot)
        screenshotView.contentMode = .ScaleAspectFit
        screenshotView.backgroundColor = UIColor.clearColor()
        screenshotView.bounds = self.bounds
        //screenshotView.frame = CGRectMake(self.screenshot!.size.width/2, self.screenshot!.size.height/2, (self.screenshot!.size.width)/3, (screenshot!.size.height)/3)
        screenshotView.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);
        self.contentView.addSubview(screenshotView)
        
        var layer = screenshotView.layer
        layer.shadowOffset = CGSizeMake(1,1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.6
        //layer.shadowPath = UIBezierPath(rect:CGRectMake(0, 0, screenshotView.frame.size.width, screenshotView.frame.size.height)).CGPath
        
    }
    
    override func prepareForReuse() {
        //print("prepareForReuse()")
        super.prepareForReuse()
        // self.label.text = @"";
    }
    
    var screenshotSize: CGSize {
        get {
            return CGSizeMake(self.screenshot!.size.width, self.screenshot!.size.height)
        }
    }
    
    /*
    func getScreenshotSize() -> CGSize {
        return CGSizeMake(self.screenshot!.size.width, self.screenshot!.size.height)
    }
    */
}