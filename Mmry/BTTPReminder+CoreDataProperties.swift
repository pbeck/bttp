//
//  BTTPReminder+CoreDataProperties.swift
//  Back to the Photo
//
//  Created by Pelle Beckman on 2015-12-17.
//  Copyright © 2015 Beckman Creative. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BTTPReminder {

    @NSManaged var creationDate: NSDate?
    @NSManaged var fireDate: NSDate?
    @NSManaged var image: NSData?
    @NSManaged var hasBeenShown: NSNumber?
    @NSManaged var assetRef: String?

}
