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
import CoreData

let ScreenshotCellIdentifier = "SCREENSHOTCELLIDENTIFIER"

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var collectionView:UICollectionView?
    @IBOutlet var startImageView:UIImageView?
    @IBOutlet var addButton:UIButton?
    
    var lastImage:UIImage?
    var lastImageAssetRef:String?
    
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Picked image")
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("showAddPhotoSegue", sender: nil)
    }
    
    @IBAction func showAddPhotoSheet(sender:AnyObject) {
        
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
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.synchronous = true
                manager.requestImageForAsset(controller.selectedImageAssets[0], targetSize: CGSize(width: 800.0, height: 8000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    self.lastImage = thumbnail
                    // Get Ref
                    
                })
                
                self.lastImageAssetRef = controller.selectedImageAssets[0].localIdentifier
                self.performSegueWithIdentifier("showAddPhotoSegue", sender: nil)
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
            let tbl = segue.destinationViewController as! TinyPhotoLibraryViewController
            tbl.firstViewController = self
        } else if segue.identifier == "showAddPhotoSegue" {
         
            if let controller = segue.destinationViewController as? AddPhotoController {
                controller.image = self.lastImage
                controller.assetRef = self.lastImageAssetRef
                controller.delegate = self
            }
        }
    }
    
    func testLog() {
        print("FirstViewController testLog()")
    }
    
    func updateCollectionView(image:UIImage) {
        //self.screenshotsCollectionController.rel
    }

}

