//
//  ScreenshotCell.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-11-29.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit

// http://stackoverflow.com/questions/29779128/how-to-make-a-random-background-color-with-swift
func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}


class ScreenshotCell: UICollectionViewCell {
    var label:UILabel?
    var screenshotView:UIImageView
    var createReminderButton:UIButton?
    var screenshot:UIImage {
        set {
            self.screenshotView.image = newValue
        }
        
        get {
            return self.screenshotView.image!
        }
    }
        
    var screenshotSize: CGSize {
        get {
            return CGSizeMake(self.screenshot.size.width, self.screenshot.size.height)
        }
    }
    
    override init(frame: CGRect) {
        self.screenshotView = UIImageView()
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.screenshotView = UIImageView()
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        // For debugging
        self.backgroundColor = UIColor.randomColor()
        
        
        /*
        self.label = UILabel.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.label!.font = UIFont.boldSystemFontOfSize(60)
        self.label!.textAlignment = NSTextAlignment.Center
        self.label!.textColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.label!)
        */
        
        //self.screenshotView.bounds = CGRectInset(self.frame, 10.0, 10.0);
        
        screenshotView.contentMode = .ScaleAspectFit
        screenshotView.opaque = true
        screenshotView.backgroundColor = UIColor.clearColor()
        screenshotView.bounds = CGRectInset(self.bounds, 10.0, 20.0)
        screenshotView.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);
        
        let layer = screenshotView.layer
        layer.shadowOffset = CGSizeMake(0,1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        
        self.contentView.addSubview(screenshotView)
    }

    override func prepareForReuse() {
        // TODO: Clear shadow CALayer?
        super.prepareForReuse()
    }
    
    
    
}