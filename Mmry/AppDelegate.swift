//
//  AppDelegate.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

// http://www.swifttoolbox.io

// http://www.raywenderlich.com/92428/background-modes-ios-swift-tutorial
// https://developer.apple.com/library/mac/recipes/xcode_help-scheme_editor/Articles/EnablingBackgroundContentFetching.html

import UIKit
import Photos
import CoreMotion

// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
    let isSimulator = true
#else
    let isSimulator = false
#endif

//#define beep() AudioServicesPlaySystemSound(1005);



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, PHPhotoLibraryChangeObserver {

    var window: UIWindow?
    //var time: NSDate?
    //var photoLibrary: PHPhotoLibrary?
    
    var locationManager: CLLocationManager!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let options = launchOptions {
            
            // If app is closed but gets started from a local notification this is where we end up
            if((options["UIApplicationLaunchOptionsLocalNotificationKey"]) != nil) {
                // Show notification
            }
        }

        
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [.Alert, .Badge, .Sound],
                categories: nil))
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        return true
    }
    
    func photoLibraryDidChange(changeInfo: PHChange) {
        print("photoLibraryDidChange()")
        /*
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResults:PHFetchResult
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if(fetchResults.count > 0) {
            fetchResults.enumerateObjectsUsingBlock { (object, _, _) in
                if let asset = object as? PHAsset {
                    
                    if(isSimulator) {
                        if asset.pixelWidth == 750 && asset.pixelHeight == 1334 {
                            self.shots.append(ScreenshotsCollectionViewController.BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
                        }
                    }
                    else {
                        if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                            self.shots.append(ScreenshotsCollectionViewController.BCShot(creationDate: NSDate(), haveNotified: false, asset: asset, UUID: NSUUID()))
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

        */
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        print(notification.userInfo!["UUID"])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowReminder") as! ShowReminderViewController
        self.window!.rootViewController!.presentViewController(vc, animated: true, completion: nil)
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Reload photos here")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //
    }
    
}

