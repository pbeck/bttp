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
import MobileCoreServices


let ScreenshotCellIdentifier = "SCREENSHOTCELLIDENTIFIER"

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var collectionView:UICollectionView?
    @IBOutlet var startImageView:UIImageView?
    @IBOutlet var addButton:UIButton?
    
    var addPhotoController:AddPhotoController?
    var screenshotsCollectionController = ScreenshotsCollectionViewController()
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setNeedsStatusBarAppearanceUpdate()
        
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
        
        addNewImage(UIImage(named: "screenshot-imessage-iphone6")!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning()")
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    func addNewImage(image:UIImage) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        
        self.view.layer.addAnimation(transition, forKey: kCATransition)
        
        self.addPhotoController = AddPhotoController(withImage: image)
        self.addPhotoController?.modalPresentationStyle = .OverFullScreen
        self.addPhotoController?.modalTransitionStyle = .CrossDissolve
        //self.presentViewController(self.addPhotoController!, animated: false, completion: )
        self.presentViewController(self.addPhotoController!, animated: false) { () -> Void in
            print("Done")
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Picked image")
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.setNeedsStatusBarAppearanceUpdate()
        self.addNewImage(image)
    }
    
    /*
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        return
    }
    */
    
    /*
    @IBAction func addMedia(sender:AnyObject) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.Default, handler: { (actionSheetController) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera;
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }))

        alertController.addAction(UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: UIAlertActionStyle.Default, handler: { (actionSheetController) -> Void in
            
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
       
        presentViewController(alertController, animated: true, completion: nil)
    }
    */
    
    @IBAction func addMedia(sender:AnyObject) {        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func unwindFromTinyPhotoLibrary(sender: UIStoryboardSegue)
    {
        print("unwindFromTinyPhotoLibrary")
        let sourceViewController = sender.sourceViewController
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func presentPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "tpl-segue") {
            print("Equals!")
            var tbl = segue.destinationViewController as! TinyPhotoLibraryViewController 
            tbl.firstViewController = self
        }
    }
}

