//
//  FirstViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import Photos

class FirstViewController: UIViewController {
    
    @IBOutlet var updateLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status != PHAuthorizationStatus.Authorized {
                    print("Didn't authorize")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI() {
        print("updateUI")
        /*
        if let time = time {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .LongStyle
            updateLabel?.text = formatter.stringFromDate(time)
        }
        else {
            updateLabel?.text = "Not yet updated"
        }
        */
    }
    
    @IBAction func didTapUpdate(sender: UIButton) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.fetch { self.updateUI() }
    }
}

