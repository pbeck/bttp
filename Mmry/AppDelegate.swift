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



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    //var time: NSDate?
    //var photoLibrary: PHPhotoLibrary?
    
    var locationManager: CLLocationManager!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
  
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways {
            CLLocationManager().requestAlwaysAuthorization()
        }
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [.Alert, .Badge, .Sound],
                categories: nil))
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            print("---")
            print("Background fetch")
            print("---")
            if let tabBarController = self.window?.rootViewController as? UITabBarController,
                viewControllers = tabBarController.viewControllers! as? [UIViewController] {
                    for viewController in viewControllers {
                        if let firstViewController = viewController as? FirstViewController {
                            firstViewController.fetch {
                                firstViewController.updateUI()
                                completionHandler(.NewData)
                            }
                        }
                    }
            }
            /*
            let vc = self.window?.rootViewController.
            self.window?.rootViewController.first
            completionHandler(.NewData)
            */
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

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            print("Heading changed")
            if let tabBarController = UIApplication.sharedApplication().windows[0].rootViewController as? UITabBarController,
                viewControllers = tabBarController.viewControllers! as? [UIViewController] {
                    for viewController in viewControllers {
                        if let firstViewController = viewController as? FirstViewController {
                            firstViewController.fetch {
                                firstViewController.updateUI()
                                //completionHandler()
                            }
                        }
                    }
            }
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("didDetermineState")
        
    }
    
    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
        print("didVisit")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("Location changed")
        if let tabBarController = UIApplication.sharedApplication().windows[0].rootViewController as? UITabBarController,
            viewControllers = tabBarController.viewControllers! as? [UIViewController] {
                for viewController in viewControllers {
                    if let firstViewController = viewController as? FirstViewController {
                        firstViewController.fetch {
                            firstViewController.updateUI()
                            //completionHandler()
                        }
                    }
                }
        }
    }
}

