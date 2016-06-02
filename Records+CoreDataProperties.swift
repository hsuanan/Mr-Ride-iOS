//
//  Records+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/2/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Records {

    @NSManaged var distance: NSNumber?
    @NSManaged var duration: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var locations: NSObject?
    @NSManaged var calories: NSNumber?

}
