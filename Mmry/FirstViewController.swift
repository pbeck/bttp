//
//  FirstViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import Photos
import PermissionScope


let ScreenshotCellIdentifier = "SCREENSHOTCELLIDENTIFIER"

class FirstViewController: UIViewController {

    @IBOutlet var collectionView:UICollectionView?
    var screenshotsCollectionController = ScreenshotsCollectionViewController()
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.addPermission(PhotosPermission(),
            message: "Photos")
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
            message: "Notifications")
        //multiPscope.headerLabel = "Permissions"
        pscope.show({ (finished, results) -> Void in
            print("got results \(results)")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
        })
       
        // For debugging
        // collectionView?.backgroundColor = UIColor.redColor()
      
        let collectionViewLayout = ScreenshotsCollectionViewFlowLayout()
        collectionView?.setCollectionViewLayout(collectionViewLayout, animated: false)
        collectionView?.registerClass(ScreenshotCell.self, forCellWithReuseIdentifier:ScreenshotCellIdentifier)
        //collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: shots.count - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        
        collectionView?.delegate = self.screenshotsCollectionController
        collectionView?.dataSource = self.screenshotsCollectionController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    @IBAction func showSettings(sender:AnyObject) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Settings")// as! SettingsViewController
        self.presentViewController(vc, animated: true, completion: nil)
        */
    }
    
    @IBAction func addMedia(sender:AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        alertController.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

