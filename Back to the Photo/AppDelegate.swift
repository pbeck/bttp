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
import CoreData


// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
    let isSimulator = true
#else
    let isSimulator = false
#endif

//#define beep() AudioServicesPlaySystemSound(1005);


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PHPhotoLibraryChangeObserver {

    var window: UIWindow?
    
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
        
        self.updateDynamicShortcutItems()
        self.shouldQuickAdd()
        
        return true
    }
    
    // TODO: Check only screenshots or not based on user settings
    func shouldQuickAdd() -> PHAsset? {
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResults:PHFetchResult
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if(fetchResults.count > 0) {
            if let asset = fetchResults.objectAtIndex(0) as? PHAsset {
                if(isSimulator) {
                    if asset.pixelWidth == 750 && asset.pixelHeight == 1334 {
                        print("There's a new screenshot in town!")
                        return asset
                    }
                } else {
                    if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                        return asset
                    }
                }
            } else {
                fatalError("Error in shouldQuickAdd: could not cast asset to PHAsset")
            }
        }
        // No images in library
        return nil;
    }
    
    // This gets called when we return from background state and
    // something changed in the system wide photo library.
    func photoLibraryDidChange(changeInfo: PHChange) {
        print("photoLibraryDidChange()")
        
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        var fetchResults:PHFetchResult
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if(fetchResults.count > 0) {
            fetchResults.enumerateObjectsUsingBlock { (object, _, _) in
                if let asset = object as? PHAsset {
                    
                    if(isSimulator) {
                        if asset.pixelWidth == 750 && asset.pixelHeight == 1334 {
                            print("There's a new screenshot in town!")
                        }
                    }
                    else {
                        if asset.mediaType == .Image && asset.mediaSubtypes == .PhotoScreenshot {
                            print("There's a new screenshot in town!")
                            /*
                            if let viewControllers = navigationController?.viewControllers {
                                for viewController in viewControllers {
                                    // some process
                                    if viewController.isKindOfClass(FirstViewController) {
                                        let vc = self.window?.rootViewController as! FirstViewController
                                        vc.addNewImage(self.getAssetUIImage(asset))
                                    }
                                } 
                            }
                            */
                            
                        } else {
                            print("Something changed but that wasn't a new screenshot")
                        }
                    }
                }
            }
        }
    }
    
    func getAssetUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 3000.0, height: 3000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        print(notification.userInfo!["UUID"])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowReminder") as! ShowReminderViewController
        vc.assetRef = String(notification.userInfo!["ASSET_REF"])
        vc.reminderURI = notification.userInfo!["REMINDER_URI"] as! String
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
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        self.updateDynamicShortcutItems()
    }
    
    func updateDynamicShortcutItems() {
        //let recentDocs = Document.recent(2)
        var shortcutItems = [UIMutableApplicationShortcutItem]()
        
        for i in 0...4 {
            shortcutItems.append(
                UIMutableApplicationShortcutItem(
                    type: "se.beckmancreative.mmry.shortcut",
                    localizedTitle: "Title",
                    localizedSubtitle: "Subtitle",
                    icon: UIApplicationShortcutIcon(type: .Compose),
                    userInfo: [ "url": "spaceships://documents/\(i)" ]
                )
            )
        }
        
        UIApplication.sharedApplication().shortcutItems = shortcutItems
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xxx.ProjectName" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BTTPModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ProjectName.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
}

