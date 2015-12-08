//
//  AboutViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-08.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView!.delegate = self
        let url = NSBundle.mainBundle().URLForResource("about", withExtension:"html")
        webView?.loadRequest(NSURLRequest(URL: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == UIWebViewNavigationType.LinkClicked) {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
