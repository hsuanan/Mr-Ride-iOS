//
//  Records+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/13/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Records {

    @NSManaged var averageSpeed: NSNumber?
    @NSManaged var calories: NSNumber?
    @NSManaged var distance: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var totalDistance: NSNumber?
    @NSManaged var totalAverageSpeed: NSNumber?
    @NSManaged var totalCount: NSNumber?
    @NSManaged var location: NSOrderedSet?

}
