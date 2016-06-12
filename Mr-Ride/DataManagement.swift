////
////  DataManagement.swift
////  Mr-Ride
////
////  Created by Hsin An Hsu on 6/9/16.
////  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//
//
//class DataManager {
//    
//    static let sharedDataManager = DataManager()
//    
//    
//    func fetchRecordsCoreData(){
//        
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Records")
//        
//        do {
//            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
//            
//            
//            guard let lastRecord = fetchedRecords.last
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get last record");
//                    return }
//            
//            guard
//                let distance = lastRecord.distance,
//                let calories = lastRecord.calories,
//                let duration = lastRecord.duration,
//                let averageSpeed = lastRecord.averageSpeed,
//                let locationSet = lastRecord.location
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
//                    return }
//            
//            guard let loctionArray = locationSet.array as? [Location]
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
//                    return }
//            
//            for location in loctionArray {
//                
//                //                print("latitude:\(location.latitude) longitude:\(location.longitude)")
//                
//                guard
//                    let latitude = location.latitude as? Double,
//                    let longitude = location.longitude as? Double
//                    
//                    else {continue}
//                //             locationList.append(
//                //                 Locations(latitude: latitude, longitude: longitude))
//                
//            }
//            
//            
//            
//            
//        } catch {
//            let fetchError = error as NSError
//            print("fetchError:\(fetchError)")
//        }
//    }
//    
//}
