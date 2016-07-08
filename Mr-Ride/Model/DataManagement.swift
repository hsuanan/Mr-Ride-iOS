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
import JWT
import CoreLocation

protocol JSONDataDelegation: class {
    func didReceiveDataFromServer()
    func didReceiveDataFromCoreData()
}

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

struct StationModel{
    
    var station: String = ""
    var district: String = ""
    var location: String = ""
    var availableBikesNumber: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}


class DataManager {
    
    static let sharedDataManager = DataManager()
    
    lazy var moc: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var saveRecords = [RecordsModel2]()
    
    var stationArray = [StationModel]()
    
    weak var delegate: JSONDataDelegation?
    
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
    
    //MARK: UBike Data
    func getBikeDataFromServer(){
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)){
        
            Alamofire.request(
                .GET,
                "http://data.taipei/youbike")
                .validate()
                .responseJSON {
                    response in
                    
                    guard let json = response.result.value as? [String: AnyObject]
                    
                        else{
//                            self.fetchStationCoreData()
//                            //self.showStationCoreData() //test if get data
//                            
//                            dispatch_async(dispatch_get_main_queue()) { [weak self] in
//                                self?.delegate?.didReceiveDataFromCoreData()
//                                return}
                            print (response.response)
                            return
                    }
//                    self.cleanUpStationCoreData()
                    self.readJSONObject(json)
//                    self.SaveStationToCoreData()
//                    //self.showStationCoreData() //test if get data
                    
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        self?.delegate?.didReceiveDataFromServer()
                    }
                    print (response.response)
            }
        }
    }
    
    
    func readJSONObject(json: [String: AnyObject]){
        
        guard
            let data = json["retVal"] as? [String:AnyObject]
            else {
                print("readJSONObject error")
                return }
        
        for value in data.values {
            
            guard
                let station = value["snaen"] as? String,
                let district = value["sareaen"] as? String,
                let location = value["aren"] as? String,
                let availableBikesNumber = value["sbi"] as? String,
                let latitude = value["lat"] as? String,
                let longitude = value["lng"] as? String
                else { continue }
            
            stationArray.append(
                StationModel(
                    station: station,
                    district: district,
                    location: location,
                    availableBikesNumber: Int(availableBikesNumber)!,
                    latitude: Double(latitude)!,
                    longitude: Double(longitude)!))
        }
    }
    
//    func SaveStationToCoreData(){
//        
//        for dataInfo in stationArray {
//            
//            let entityStation = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: moc) as! Station
//            
//            entityStation.district = dataInfo.district
//            entityStation.station = dataInfo.station
//            entityStation.location = dataInfo.location
//            entityStation.avaliableBikesNumber = dataInfo.availableBikesNumber
//            entityStation.latitude = dataInfo.latitude
//            entityStation.longitude = dataInfo.longitude
//            
//            do {
//                try moc.save()
//                
//            }catch{
//                fatalError("Failure to save station coredata: \(error)")
//            }
//        }
//    }
//    
//    func fetchStationCoreData(){
//        
//        let fetchStationRequest = NSFetchRequest(entityName: "Station")
//        
//        do {
//            let fetchedStation = try moc.executeFetchRequest(fetchStationRequest) as! [Station]
//            
//            for eachFethcStationData in fetchedStation {
//                guard
//                    let station = eachFethcStationData.station,
//                    let district = eachFethcStationData.district,
//                    let location = eachFethcStationData.location,
//                    let availableBikesNumber = eachFethcStationData.avaliableBikesNumber as? Int,
//                    let latitude = eachFethcStationData.latitude as? Double,
//                    let longitude = eachFethcStationData.longitude as? Double
//                    else { continue }
//                
//                self.stationArray.append(
//                    StationModel(
//                        station: station,
//                        district: district,
//                        location: location,
//                        availableBikesNumber: availableBikesNumber,
//                        latitude: latitude,
//                        longitude: longitude))
//            }
//            print("Fetch data from coredata")
//            
//        } catch {
//            fatalError("Failed to fetch coredata: \(error)")
//        }
//    }
//    
//    
//    func cleanUpStationCoreData(){
//        let request = NSFetchRequest(entityName: "Station")
//        
//        do {
//            let results = try moc.executeFetchRequest(request) as! [Station]
//            
//            for result in results {
//                moc.deleteObject(result)
//            }
//            do {
//                try moc.save()
//            } catch {
//                fatalError("Failure to save context: \(error)")
//            }
//        }catch {
//            fatalError("Failure to cleanup station coredata: \(error)")
//        }
//    }
//    
//    func showStationCoreData(){
//        let request = NSFetchRequest(entityName: "Station")
//        
//        do {
//            let results = try moc.executeFetchRequest(request) as! [Station]
//            
//            for result in results {
//                print ("station name: \(result.station!) ")
//                print ("availableBikeNumbers: \(result.avaliableBikesNumber!)")
//            }
//        }catch {
//            fatalError("fail to fech data: \(error)")
//        }
//    }
//    
}
