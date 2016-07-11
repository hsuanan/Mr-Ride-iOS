////
////  DataManagement.swift
////  Mr-Ride
////
////  Created by Hsin An Hsu on 6/9/16.
////  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
////
//
import Foundation
import CoreData
import Alamofire
import CoreLocation


struct Locations{
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}

struct RecordsModel {
    
    var timestamp = NSDate()
    var distance = 0.0
    var calories = 0.0
    var duration = 0.0
    var averageSpeed = 0.0
    var location = [Locations]()
}

struct RecordsModel2 {
    var timestamp = NSDate()
    var distance = 0.0
    var totalCount = 0
    var duration = 0.0
}

class DataManager {
    
    static let sharedDataManager = DataManager()
    
    var saveRecords = [RecordsModel2]()
    
    lazy var moc: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    //MARK: Records Data
    func fetchRecordsCoreData(){
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let date = NSDate()
        fetchRequest.predicate = NSPredicate(format: "timestamp <= %@", date )
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dateForSection", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print ("Unable to perform fetch: \(error.localizedDescription)")
        }
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
            
            saveRecords.removeAll()
            
            for eachFetchedRecord in fetchedRecords {
                
                guard
                    let timestemp = eachFetchedRecord.timestamp,
                    let distance = eachFetchedRecord.distance as? Double,
                    let totalCount = eachFetchedRecord.totalCount as? Int,
                    let duration = eachFetchedRecord.duration as? Double
                    
                    else {
                        print("[StaticsViewController](fetchRecordsCoreData) can't get Records")
                        continue }
                
                self.saveRecords.append(
                    RecordsModel2(
                        timestamp: timestemp,
                        distance: distance,
                        totalCount: totalCount,
                        duration: duration
                    ))
            }
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
    }
}
