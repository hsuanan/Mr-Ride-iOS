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
    
}


class DataManager {
    
    static let sharedDataManager = DataManager()
    
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var moc: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    //    var saveRecords = [RecordsModel]()
    //
    //    var locationList = [Locations]()
    
    var saveRecords = [RecordsModel2]()
    
    
    
    func fetchRecordsCoreData(){
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let date = NSDate()
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", date )
        //        fetchRequest.fetchBatchSize = 10
        //        fetchRequest.fetchLimit = 1
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dateForSection", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
            print ("fetchedResultsController.performFetch")
            
        } catch let error as NSError {
            print ("Unable to perform fetch: \(error.localizedDescription)")
        }
        
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
            
            saveRecords.removeAll()
            
            for eachFetchedRecord in fetchedRecords {
                
                guard
                    let timestemp = eachFetchedRecord.timestamp,
                    let distance = eachFetchedRecord.distance as? Double
                    
                    else {
                        print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
                        continue }
                
                saveRecords.append(
                    RecordsModel2(
                        timestamp: timestemp,
                        distance: distance))
            }
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
        
        
        
        
        //// storing data to array will cause memory usege raise
        //        do {
        //            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
        //
        ////            print("fetchedRecords: \(fetchedRecords)")
        //
        //            saveRecords.removeAll()
        //
        //            for eachFetchedRecord in fetchedRecords {
        //
        //                guard
        //                    let timestemp = eachFetchedRecord.timestamp,
        //                    let distance = eachFetchedRecord.distance as? Double,
        //                    let calories = eachFetchedRecord.calories as? Double,
        //                    let duration = eachFetchedRecord.duration as? Double,
        //                    let averageSpeed = eachFetchedRecord.averageSpeed as? Double,
        //                    let locationSet = eachFetchedRecord.location
        //
        //                    else {
        //                        print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
        //                        continue }
        //
        //                guard let loctionArray = locationSet.array as? [Location]
        //
        //                    else {
        //                        print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
        //                        return }
        //
        //                locationList.removeAll()  // 清空之前的array
        //
        //                for location in loctionArray {
        //
        ////                    print("latitude:\(location.latitude) longitude:\(location.longitude)")
        //
        //                    guard
        //                        let latitude = location.latitude as? Double,
        //                        let longitude = location.longitude as? Double
        //
        //                        else {
        //                            print("[StaticsViewController](fetchRecordsCoreData) can't get latitude and logitude");
        //                            continue}
        //                    locationList.append(
        //                        Locations(latitude: latitude, longitude: longitude))
        //
        //                }
        //                saveRecords.append(
        //                    RecordsModel(
        //                        timestamp: timestemp,
        //                        distance: distance,
        //                        calories: calories,
        //                        duration: duration,
        //                        averageSpeed: averageSpeed,
        //                        location: locationList))
        //            }
        //            
        //        } catch {
        //            let fetchError = error as NSError
        //            print("fetchError:\(fetchError)")
        //        }
    }
    
}
