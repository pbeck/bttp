//
//  FirstViewController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-10-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import Photos

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
        
        var collectionViewLayout = ScreenshotsCollectionViewFlowLayout()
        collectionView?.setCollectionViewLayout(collectionViewLayout, animated: false)
        collectionViewLayout.scrollDirection = .Horizontal

        self.collectionView?.registerClass(ScreenshotCell.self, forCellWithReuseIdentifier:"CELL")
        
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
            return 120;
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! ScreenshotCell
            cell.label?.text = "\(indexPath.row)"
            return cell
            
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        print("Tocuhed \(cell) at \(indexPath)")
    }
    
    /*
    - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
    {
    return 1;
    }
    
    -(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
    }
    
    -(CustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setTitle:[NSString stringWithFormat:@"%d", indexPath.row]];
    return cell;
    }
    */
}

