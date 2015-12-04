//
//  SecondViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var stackView:UIStackView!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad() SVC")

        for _ in 0...9 {
            
            /*
            let image = UIImage(named:"screenshot-debug-iphone6")
            //let imageView = UIImageView(image: image)
            let imageView = UIImageView(frame: CGRectMake(100, 150, 150, 100))
            imageView.image = image
            //imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.bounds = CGRectInset(imageView.frame, 20.0, 20.0)
            //imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            */
            
            let image = UIImage(named:"screenshot-debug-iphone6")
            stackView.addArrangedSubview(ScreenshotView(image: image!))            
            
        }
        print(stackView.arrangedSubviews.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

