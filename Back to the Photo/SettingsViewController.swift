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
    @IBOutlet var twitterCell:UITableViewCell?
    @IBOutlet var webView:UIWebView?
    @IBOutlet var quickAddScreenshotsOnlySwitch:UISwitch?
    @IBOutlet var screenshotsOnlySwitch:UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let clickedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if(clickedCell == twitterCell) {
            self.openTwitter(self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let userDefs = NSUserDefaults.standardUserDefaults()
        /*
        self.quickAddScreenshotsOnlySwitch =
        let qa = userDefs.valueForKey("quickadd_only_for_screenshots")
        let so = userDefs.valueForKey("use_screenshots_only")
        */
        
        NSUserDefaults.standardUserDefaults().synchronize()
    
    }
    
    @IBAction func setQuickAddOnlyScreenshots(sender:AnyObject) {
        
    }
    
    @IBAction func openTwitter(sender:AnyObject) {
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
