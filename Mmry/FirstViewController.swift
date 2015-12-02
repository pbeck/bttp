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

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CNPGridMenuDelegate {

    struct BCShot {
        var creationDate = NSDate()
        var haveNotified:Bool = false
        var asset:PHAsset
        //var UUID:String
    }
    
    var gridmenu:CNPGridMenuItem?
    var shots:[BCShot] = []
    
    @IBOutlet var updateLabel: UILabel?
    var time:NSDate?
    var photoLibrary:PHPhotoLibrary?
    @IBOutlet var collectionView:UICollectionView?
    
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.addPermission(PhotosPermission(),
            message: "Photos")
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
            message: "Notifications")
        //multiPscope.headerLabel = "Permissions"
       
        
        buildScreenshotList()
        
        let collectionViewLayout = ScreenshotsCollectionViewFlowLayout()
        collectionView?.setCollectionViewLayout(collectionViewLayout, animated: false)
        collectionViewLayout.scrollDirection = .Horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        pscope.show({ (finished, results) -> Void in
            print("got results \(results)")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
        })

        // For debugging
        // collectionView?.backgroundColor = UIColor.redColor()
        
        collectionView?.pagingEnabled = true

        self.collectionView?.registerClass(ScreenshotCell.self, forCellWithReuseIdentifier:"CELL")
        
        
        
        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: shots.count - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            self.shots.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset))
                        }
                    }
                    else {
                        if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                            self.shots.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset))
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
            return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            cell.screenshot = getAssetUIImage(shots[indexPath.row].asset)
            cell.addScreenshot()
            //cell.backgroundColor = UIColor.randomColor()
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.showGridMenu()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            //print(self.collectionView!.frame.height)
            return CGSizeMake(320, self.collectionView!.frame.height - 160)
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
    
    func showGridMenu() {
        
        let laterToday:CNPGridMenuItem = CNPGridMenuItem()
        laterToday.icon = UIImage(named: "LaterToday")
        laterToday.title = "Later Today"
        
        let thisEvening:CNPGridMenuItem = CNPGridMenuItem()
        thisEvening.icon = UIImage(named: "ThisEvening")
        thisEvening.title = "This Evening"
        
        let tomorrow:CNPGridMenuItem = CNPGridMenuItem()
        tomorrow.icon = UIImage(named: "Tomorrow")
        tomorrow.title = "Tomorrow"
        
        let thisWeekend:CNPGridMenuItem = CNPGridMenuItem()
        thisWeekend.icon = UIImage(named: "ThisWeekend")
        thisWeekend.title = "This Weekend"
        
        let nextWeek:CNPGridMenuItem = CNPGridMenuItem()
        nextWeek.icon = UIImage(named: "NextWeek")
        nextWeek.title = "Next Week"
        
        let inAMonth:CNPGridMenuItem = CNPGridMenuItem()
        inAMonth.icon = UIImage(named: "InMonth")
        inAMonth.title = "In a Month"
        
        let someday:CNPGridMenuItem = CNPGridMenuItem()
        someday.icon = UIImage(named: "Someday")
        someday.title = "Someday"
        
        let pickDate:CNPGridMenuItem = CNPGridMenuItem()
        pickDate.icon = UIImage(named: "PickDate")
        pickDate.title = "Pick Date"
        
        let debug5secs:CNPGridMenuItem = CNPGridMenuItem()
        debug5secs.icon = UIImage(named: "Desktop")
        debug5secs.title = "Debug"
        
        
        let gridMenu = CNPGridMenu(menuItems:[laterToday, thisEvening, tomorrow, thisWeekend, nextWeek, inAMonth, someday, pickDate, debug5secs])
        gridMenu.delegate = self
        self.presentGridMenu(gridMenu, animated: true) { () -> Void in
            print("Grid menu")
        }
    }
    
    func gridMenuDidTapOnBackground(menu: CNPGridMenu!) {
        self.dismissGridMenuAnimated(true) { () -> Void in
            print("Grid menu dismissed")
        }
    }
    
    func gridMenu(menu: CNPGridMenu!, didTapOnItem item: CNPGridMenuItem!) {
        self.dismissGridMenuAnimated(true) { () -> Void in
            let now = NSDate()
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
        
            switch(item.title) {
             
                
                case "Later Today":
                    self.setNotification(NSDate().dateByAddingTimeInterval(60.0 * 60.0))
                break
                
                case "This Eventing":
                    components!.hour = 20
                    self.setNotification((calendar?.dateFromComponents(components!))!)
                break
                
                case "Tomorrow":
                    // 24 hours ahead or 08:00 am?
                break
                
                case "ThisWeekend":
                    // The coming saturday
                break
                
                case "NextWeek":
                    // The coming monday
                break
                
                case "InMonth":
                    // Beginning of next month or 30 days?
                break
                
                case "Someday":
                    // 3 months from now
                break
                
                case "PickDate":
                    DatePickerDialog().show("Pick a Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
                        (date) -> Void in
                        print("\(date)")
                    }
                break
                
                case "Debug":
                    self.setNotification(NSDate().dateByAddingTimeInterval(5.0))
                break
                
                default:
                    // ...
                break
            }
        }
    }
    
    private let ITEMS_KEY = "todoItems"
    
    func setNotification(date: NSDate) {
        /*
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        */
        
        let notification = UILocalNotification()
        
        notification.alertTitle = "Mmry"
        
        let emojis = ["⏰", "🎉", "💻", "🌈"]
        let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
        notification.alertBody = "There's a reminder waiting for you! \(emojis[randomIndex]) "
        
        notification.fireDate = date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": "test"]
        notification.category = "TODO_CATEGORY"
        notification.applicationIconBadgeNumber = 1;
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}

