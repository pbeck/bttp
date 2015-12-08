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
    
    var screenshotsCollectionController = ScreenshotsCollectionViewController()
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
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
        print("didReceiveMemoryWarning()")
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func addNewImage(image:UIImage) {
        let imageView = UIImageView(image: image)
        UIView.transitionWithView(self.view, duration: 1.2, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {self.view.addSubview(imageView)}, completion: nil)
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
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)

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
}

