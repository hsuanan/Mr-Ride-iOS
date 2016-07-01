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
    
    var dateForSection: String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM, YYYY"
        return dateFormatter.stringFromDate(timestamp!)
        
        
//        let calendar = NSCalendar.currentCalendar()
//        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: timestamp!)
//        dateComponents.timeZone = NSTimeZone(name: "CST")
//        let sectionName = String(dateComponents.month) + ", " + String(dateComponents.year)
//        return sectionName
    }

}
