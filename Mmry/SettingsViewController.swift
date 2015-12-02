//
//  SettingsViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-01.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    //@IBOutlet var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func openTwitter() {
        let screenName =  "pbeck"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.sharedApplication()
        
        if application.canOpenURL(appURL) {
            application.openURL(appURL)
        } else {
            application.openURL(webURL)
        }
    }

}
