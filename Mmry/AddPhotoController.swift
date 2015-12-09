//
//  AddPhotoController.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-09.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import UIKit
import CoreMotion

class AddPhotoController: UIViewController, CNPGridMenuDelegate {
    
    var image:UIImage
    //var cardView:SpringView
    var imageView:SpringImageView
    
    let motionManager:CMMotionManager
    
    init(withImage image:UIImage) {
        self.image = image
        self.imageView = SpringImageView(image: self.image)
        self.motionManager = CMMotionManager()
        //self.cardView = SpringView()
        
        super.init(nibName: nil, bundle: nil)
        
        /*
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) { (data: CMAccelerometerData?, error: NSError?) in
                
                let rotation = atan2(data!.acceleration.x, data!.acceleration.y) - M_PI
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
            }
        }
        */
        
        print("init(withImage)")
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
        self.view.userInteractionEnabled = true
        
        /*
        self.cardView.bounds = CGRectInset(self.view.bounds, 40.0, 60.0)
        self.cardView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        self.cardView.backgroundColor = UIColor.blueColor()
        //self.cardView.alpha = 0.0
        
        self.view.addSubview(self.cardView)
        */
        
        imageView.alpha = 0.0
        imageView.contentMode = .ScaleAspectFit
        imageView.opaque = true
        imageView.backgroundColor = UIColor.clearColor()
        imageView.bounds = CGRectInset(self.view.bounds, 40.0, 60.0)
        imageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);

        let layer = imageView.layer
        layer.shadowOffset = CGSizeMake(0,1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 26
        layer.shadowOpacity = 0.5


        self.view.addSubview(imageView)
        //self.cardView.addSubview(imageView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        UIView.beginAnimations("fade-bg-in", context: nil)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationCurve(.EaseInOut)
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        UIView.commitAnimations()
        
        self.imageView.animation = "slideUp"
        self.imageView.curve = "easeIn"
        self.imageView.force = 1.8
        self.imageView.duration = 0.6
        self.imageView.animateNext { () -> () in
            self.showGridMenu()
        }
        
        /*
        let layer:CALayer = self.imageView.layer
        var rot:CATransform3D = CATransform3DIdentity
        rot.m34 = 1.0 / -500
        rot = CATransform3DRotate(rot, CGFloat(45.0 * M_PI), 0.0, 1.0, 0.0)
        layer.transform = rot
        */
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateDiscardedAndDismiss() {
        self.imageView.animation = "fall"
        self.imageView.animateFrom = true
        self.imageView.curve = "easeIn"
        self.imageView.force = 0.6
        self.imageView.duration = 0.6
        
        self.imageView.animateToNext({
            self.imageView.animation = "fadeOut"
            self.imageView.duration = 0.4
            self.imageView.curve = "easeIn"
            self.imageView.animateToNext({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        })
    }
    
    func animateAcceptedAndDismiss() {
        self.imageView.animation = "slideRight"
        self.imageView.animateFrom = false
        self.imageView.curve = "easeIn"
        self.imageView.force = 0.6
        self.imageView.duration = 0.6
        
        self.imageView.animateToNext({
            self.imageView.animation = "fadeOut"
            self.imageView.duration = 0.4
            self.imageView.curve = "easeIn"
            self.imageView.animateToNext({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.imageView.animation = "fall"
        self.imageView.animateFrom = true
        self.imageView.curve = "easeIn"
        self.imageView.force = 0.6
        self.imageView.duration = 0.6
      
        self.imageView.animateToNext({
            self.imageView.animation = "fadeOut"
            self.imageView.duration = 0.4
            self.imageView.curve = "easeIn"
            
            self.imageView.animateToNext({
                
                UIView.beginAnimations("fade-bg-out", context: nil)
                UIView.setAnimationDuration(0.2)
                UIView.setAnimationCurve(.EaseInOut)
                self.view.backgroundColor = UIColor(red:0.24, green:0.26, blue:0.31, alpha:0.0)
                UIView.commitAnimations()
                
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        })
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
            self.animateDiscardedAndDismiss()
        }
    }
    
    func gridMenu(menu: CNPGridMenu!, didTapOnItem item: CNPGridMenuItem!) {
        self.dismissGridMenuAnimated(true) { () -> Void in
            let now = NSDate()
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
            
            switch(item.title) {
            
            
                case "Later Today":
                //self.setNotification(NSDate().dateByAddingTimeInterval(60.0 * 60.0))
                break
                
                case "This Evening":
                // TODO: What if this evening (20:00) has already passed?
                //components!.hour = 20
                //self.setNotification((calendar?.dateFromComponents(components!))!)
                break
                
                case "Tomorrow":
                // Next occurence of 08:00
                //components!.hour = 8
                //self.setNotification((calendar?.nextDateAfterDate(NSDate(), matchingComponents: components!, options: [NSCalendarOptions.MatchNextTimePreservingSmallerUnits]))!)
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
                
                case "Pick Date":
                DatePickerDialog().show("Pick a Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
                (date) -> Void in
                print("\(date)")
                }
                break
                
                case "Debug":
                //self.setNotification(NSDate().dateByAddingTimeInterval(5.0))
                break
                
                default:
                // ...
                break
            }
        
            self.animateAcceptedAndDismiss()
        }
    }


}
