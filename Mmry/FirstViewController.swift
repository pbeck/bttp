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
import ImagePickerSheetController


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
    
    @IBAction func addMedia(sender:AnyObject) {
        
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let controller = ImagePickerSheetController(mediaType: .ImageAndVideo)
        controller.maximumSelection = 1
    
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("Create reminder", comment: "Action Title"), $0) as String}, handler: { _ in
            presentImagePickerController(.PhotoLibrary)
            }, secondaryHandler: { _, numberOfPhotos in
                print("Send \(controller.selectedImageAssets)")
                
                let manager = PHImageManager.defaultManager()
                var option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.synchronous = true
                manager.requestImageForAsset(controller.selectedImageAssets[0], targetSize: CGSize(width: 800.0, height: 8000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.addNewImage(thumbnail)
        }))

        controller.addAction(ImagePickerAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
            print("Cancelled")
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            controller.modalPresentationStyle = .Popover
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize())
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Picked image")
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.setNeedsStatusBarAppearanceUpdate()
        self.addNewImage(image)
    }
    */
    
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

