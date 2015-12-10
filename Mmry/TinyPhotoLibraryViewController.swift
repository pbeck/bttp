//
//  TinyPhotoLibrary.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import Photos


class TinyPhotoLibraryViewController: UIViewController {
    
    @IBOutlet weak var modalView: SpringView!
    weak var firstViewController:FirstViewController?
    @IBOutlet var stackView: UIStackView?
    
    var photos:[UIImage]?

    override func viewWillAppear(animated: Bool) {
        
        let manager = PHImageManager.defaultManager()
        
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResults:PHFetchResult
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 5
        fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        // TODO: Check if we're only showing screenshots here from user defaults
        if(fetchResults.count > 0) {
            fetchResults.enumerateObjectsUsingBlock { (object, _, _) in
                if let asset = object as? PHAsset {
                    manager.requestImageForAsset(asset, targetSize: CGSize(width: 400.0, height: 200.0), contentMode: .AspectFit, options: nil, resultHandler: {(result, info)->Void in
                        //self.photos?.append(result!)
                        
                        let imageView = UIImageView(image: result!)
                        let singleTap = UITapGestureRecognizer(target: self, action:"tappedPhoto:")
                        //singleTap.delegate = self
                        singleTap.numberOfTapsRequired = 1
                        
                        imageView.userInteractionEnabled = true
                        imageView.addGestureRecognizer(singleTap)
                        
                        let layer = imageView.layer
                        layer.shadowOffset = CGSizeMake(0,1)
                        layer.shadowColor = UIColor.blackColor().CGColor
                        layer.shadowRadius = 2
                        layer.shadowOpacity = 0.3
                        
                        self.stackView?.addArrangedSubview(imageView)
                    })
                } else {
                    fatalError("Error in fetchResults.enumerateObjectsUsingBlock")
                }
            }
        } else {
            fatalError("No photos in library or permissions not setup correctly")
        }
    }
    

    
    func tappedPhoto(sender: UITapGestureRecognizer) {
        print("Tapped")
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.firstViewController!.addNewImage(UIImage(named: "screenshot-imessage-iphone6")!)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
        //UIApplication.sharedApplication().sendAction("maximizeView:", to: nil, from: self, forEvent: nil)
    }
}
