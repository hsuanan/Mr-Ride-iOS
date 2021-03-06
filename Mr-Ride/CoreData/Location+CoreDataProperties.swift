//
//  Location+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/8/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var record: Records?

}
