//
//  Toilet+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/27/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Toilet {

    @NSManaged var address: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var title: String?
    @NSManaged var category: String?

}
