//
//  FirstViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import Photos

// http://stackoverflow.com/questions/29779128/how-to-make-a-random-background-color-with-swift
func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

class FirstViewController: UIViewController, UICollectionViewDelegate {

    struct BCShot {
        var creationDate = NSDate()
        var haveNotified:Bool = false
    }
    
    var shots:[BCShot] = []
    
    @IBOutlet var updateLabel: UILabel?
    var time:NSDate?
    var photoLibrary:PHPhotoLibrary?
    @IBOutlet var collectionView:UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewLayout = ScreenshotsCollectionViewFlowLayout()
        collectionView?.setCollectionViewLayout(collectionViewLayout, animated: false)
        collectionViewLayout.scrollDirection = .Horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        //collectionView?.backgroundColor = UIColor.redColor()
        collectionView?.pagingEnabled = true

        self.collectionView?.registerClass(ScreenshotCell.self, forCellWithReuseIdentifier:"CELL")
        
        
        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 9, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.theData.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
       
        
        updateUI()
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status != PHAuthorizationStatus.Authorized {
                    print("Didn't authorize")
                }
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI() {
        print("updateUI")
        
        //let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        guard let thisTime = time else {
            updateLabel?.text = "Not yet updated"
            return
        }
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .LongStyle
        updateLabel?.text = formatter.stringFromDate(thisTime)
        /*
        if let time = time {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .LongStyle
            updateLabel?.text = formatter.stringFromDate(time)
        }
        else {
            updateLabel?.text = "Not yet updated"
        }
        */
        
        //UIImage
    }
    
    @IBAction func didTapUpdate(sender: UIButton) {
        //let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        fetch { self.updateUI() }
    }
    
    //http://stackoverflow.com/questions/8867496/get-last-image-from-photos-app
    
    func fetch(completion: () -> Void) {
        print("fetch()")
        time = NSDate()
        //photoLibrary = PHPhotoLibrary.sharedPhotoLibrary()
        getLatestPhotos()
        completion()
    }
    
    func loadScreenshot() {
        
        
    }
    
    func getLatestPhotos() {
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResult:PHFetchResult
        var lastAsset:PHAsset
        
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        lastAsset = fetchResult.lastObject as! PHAsset
        
        // Since we can get screenshots onto the simulator we check for measurements, not metadata
        // if(isSimulator) {
        
        if lastAsset.mediaType == .Image && lastAsset.mediaSubtypes == .PhotoScreenshot {
            //if lastAsset.pixelWidth == 750 && lastAsset.pixelHeight == 1334 {
                if !hasThisBeenNotified(lastAsset.creationDate!) {
                    shots.append(BCShot(creationDate: lastAsset.creationDate!, haveNotified: false))
                    launchNotification()
             //   }
                
            }
        }
        //print(lastAsset)
    }
    
    func launchNotification() {
        let notification = UILocalNotification()
        notification.alertBody = "Create reminder from screenshot?" // text that will be displayed in the notification
        notification.alertAction = "Create reminder" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate() // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        //notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func hasThisBeenNotified(date: NSDate) -> Bool {
        for shot in shots {
            if shot.creationDate.compare(date) == NSComparisonResult.OrderedSame {
                return true
            }
        }
        return false
    }
    
    func numberOfSectionsInCollectionView(collectionview: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            cell.setScreenshot()
            cell.label?.text = "\(indexPath.row)"
            //cell.backgroundColor = UIColor.randomColor()
            //cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.collectionView!.frame.height, self.collectionView!.frame.height);
            return cell
            
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //var cell = collectionView.cellForItemAtIndexPath(indexPath)
        //print("Tocuhed \(cell) at \(indexPath)")
        
        let alertController = UIAlertController(title: "iOScreator", message:
            "Hello, world!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            //print(self.collectionView!.frame.height)
            return CGSizeMake(400, self.collectionView!.frame.height - 160)
    }
    /*
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(10, 10, 20, 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 100
    }
    */
    
    // http://stackoverflow.com/questions/13228600/uicollectionview-align-logic-missing-in-horizontal-paging-scrollview
    /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            var pageWidth:Float = 300
    
            var currentOffset = scrollView.contentOffset.x;
            var targetOffset = targetContentOffset.memory.x
            var newTargetOffset = 0;
    
            if (targetOffset > currentOffset) {
                newTargetOffset = Int(ceilf(Float(currentOffset) / pageWidth ) * pageWidth)
            } else {
                newTargetOffset = Int(floorf(Float(currentOffset) / pageWidth) * pageWidth)
            }
    
            if (newTargetOffset < 0) {
                newTargetOffset = 0;
            } else if (newTargetOffset > Int(scrollView.contentSize.width)) {
                newTargetOffset = Int(scrollView.contentSize.width)
            }
    
            targetContentOffset.memory.x = currentOffset;
            scrollView.setContentOffset(CGPointMake(CGFloat(newTargetOffset), 0), animated:true)
    }
    */
}

