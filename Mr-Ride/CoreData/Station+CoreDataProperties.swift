//
//  Station+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/20/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Station {

    @NSManaged var station: String?
    @NSManaged var district: String?
    @NSManaged var location: String?
    @NSManaged var avaliableBikesNumber: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?

}
