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
        var haveNotified:Bool = false
        var asset:PHAsset
        var UUID:NSUUID
        
        func fireNotification() {
            print("fireNotification")
        }
    }
    
    var shots:[BCShot] = []
    var gridmenu:CNPGridMenuItem?
    var collectionView:UICollectionView?
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        self.buildScreenshotList()
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            //print(self.collectionView!.frame.height)
            return CGSizeMake(collectionView.frame.width - 50, collectionView.frame.height)
    }

    func numberOfSectionsInCollectionView(collectionview: UICollectionView) -> Int {
        return 1;
    }

    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.shots.count
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScreenshotCellIdentifier, forIndexPath: indexPath) as! ScreenshotCell
            
            cell.screenshot = getAssetUIImage(self.shots[indexPath.row].asset)
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
                            self.shots.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
                        }
                    }
                    else {
                        if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                            self.shots.append(BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
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
        
        /*
        self.presentGridMenu(gridMenu, animated: true) { () -> Void in
            print("Grid menu")
        }
        */
        
    }

    func gridMenuDidTapOnBackground(menu: CNPGridMenu!) {
        /*
        self.dismissGridMenuAnimated(true) { () -> Void in
            print("Grid menu dismissed")
        }
        */
    }

    func gridMenu(menu: CNPGridMenu!, didTapOnItem item: CNPGridMenuItem!) {
        /*
        self.dismissGridMenuAnimated(true) { () -> Void in
            let now = NSDate()
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
            
            switch(item.title) {
                
                
            case "Later Today":
                self.setNotification(NSDate().dateByAddingTimeInterval(60.0 * 60.0))
                break
                
            case "This Evening":
                // TODO: What if this evening (20:00) has already passed?
                components!.hour = 20
                self.setNotification((calendar?.dateFromComponents(components!))!)
                break
                
            case "Tomorrow":
                // Next occurence of 08:00
                components!.hour = 8
                self.setNotification((calendar?.nextDateAfterDate(NSDate(), matchingComponents: components!, options: [NSCalendarOptions.MatchNextTimePreservingSmallerUnits]))!)
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
    */
    }
    
    func hasThisBeenNotified(date: NSDate) -> Bool {
        for shot in shots {
            if shot.creationDate.compare(date) == NSComparisonResult.OrderedSame {
                return true
            }
        }
        return false
    }

    
    
    
    func setNotification(date: NSDate) {
        /*
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        */
        
        let notification = UILocalNotification()
        
        notification.alertTitle = "Mmry"
        
        let emojis = ["⏰", "🎉", "🌈"]
        let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
        notification.alertBody = "\(emojis[randomIndex]) There's a reminder waiting for you!"
        
        notification.fireDate = date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": "test"]
        notification.category = "TODO_CATEGORY"
        notification.applicationIconBadgeNumber = 1;
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

}
