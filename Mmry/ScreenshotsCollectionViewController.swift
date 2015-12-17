//
//  ScreenshotsViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-04.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ScreenshotsCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CNPGridMenuDelegate {

    struct BCShot {
        var creationDate = NSDate()
        var reminderDate = NSDate()
        //var haveNotified:Bool = false
        //var asset:PHAsset
        //var imageUrl:
        var UUID:NSUUID
    }
    
    var data:[BCShot] = []
    var gridmenu:CNPGridMenuItem?
    var collectionView:UICollectionView?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        //self.buildScreenshotList()
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            //print(self.collectionView!.frame.height)
            return CGSizeMake(collectionView.frame.width - 50, collectionView.frame.height)
    }

    func numberOfSectionsInCollectionView(collectionview: UICollectionView) -> Int {
        return 2;
    }

    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.data.count
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScreenshotCellIdentifier, forIndexPath: indexPath) as! ScreenshotCell
            
            //cell.screenshot = getAssetUIImage(self.data[indexPath.row].image)
            return cell
            
    }
    

    func getAssetUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 3000.0, height: 3000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //showGridMenu()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScreenshotCellIdentifier, forIndexPath: indexPath) as! ScreenshotCell
        UIView.transitionWithView(collectionView, duration: 0.325, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
           
            cell.frame = CGRectMake(3, 14, 100, 100)
        
            }, completion: { (finished: Bool) -> () in
                
        })
    }

    func buildScreenshotList() {
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResults:PHFetchResult
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if(fetchResults.count > 0) {
            fetchResults.enumerateObjectsUsingBlock { (object, _, _) in
                if let asset = object as? PHAsset {
                    
                    if(isSimulator) {
                        if asset.pixelWidth == 750 && asset.pixelHeight == 1334 {
                            //self.data.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
                        }
                    }
                    else {
                        if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                            //self.data.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
                            /*
                            if !hasThisBeenNotified(lastAsset.creationDate!) {
                            shots.append(BCShot(creationDate: lastAsset.creationDate!, haveNotified: false))
                            launchNotification()
                            }
                            */
                        }
                    }
                }
            }
        } else {
            fatalError("No screenshots")
        }
    }

        
    func hasThisBeenNotified(date: NSDate) -> Bool {
        for shot in data {
            if shot.creationDate.compare(date) == NSComparisonResult.OrderedSame {
                return true
            }
        }
        return false
    }

    func insertPhoto(image:UIImage) {
        //self.data.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: AnyObject, UUID: NSUUID()))
    }
}
