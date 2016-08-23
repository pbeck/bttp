//
//  ShowReminder.swift
//  Mmry
//
//  Created by Pelle Beckman on 2015-12-02.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShowReminderViewController: UIViewController {
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var doneButton:UIButton?
    @IBOutlet var remindMeLaterButton:UIButton?
    
    var image:UIImage!
    var assetRef:String!
    var reminderURI:String!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let fetchRequest = NSFetchRequest(entityName: "BTTPReminder")
        let predicate = NSPredicate(format: "assetRef == %@", assetRef)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [BTTPReminder]
            if(fetchedEntities.count > 0) {
                print("Found result")
                for item in fetchedEntities {
                    self.imageView!.image = UIImage(data: item.image!)
                }
            }
            
        } catch let error as NSError {
            print("ShowReminder was probably called without existing assetRef!\n\(error)")
        }
        */

        let objectID = managedObjectContext.persistentStoreCoordinator!.managedObjectIDForURIRepresentation(NSURL(string: self.reminderURI)!)

        do {
            let object = try managedObjectContext.existingObjectWithID(objectID!) as? BTTPReminder
            self.imageView!.image = UIImage(data: object!.image!)
        } catch {
            print("Can't find object")
        }
    }
    
    @IBAction func doneButtonPress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
