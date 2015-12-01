//
//  ScreenshotView.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-01.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotView: UIView {
    var screenshotView:UIImageView!
    var screenshotImage:UIImage!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
   
    convenience init(image screenshotImage: UIImage) {
        self.init(frame:CGRect.zero)
        self.screenshotView = UIImageView(image: screenshotImage)
        // Opaque = optimizing
        //self.screenshotView.clipsToBounds = true
        self.screenshotView.opaque = true
       
        self.screenshotView.backgroundColor = UIColor.blueColor()
        
        self.addSubview(self.screenshotView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(200.0, 200.0)
    }
    */
}