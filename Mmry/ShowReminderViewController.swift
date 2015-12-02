//
//  ShowReminder.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-02.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit

class ShowReminderViewController: UIViewController {
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var doneButton:UIButton?
    @IBOutlet var remindMeLaterButton:UIButton?
    
    override func viewDidLoad() {
        self.imageView = UIImageView(image: UIImage(named: "screenshot-debug-iphone6"))
    }
    
    @IBAction func doneButtonPress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
