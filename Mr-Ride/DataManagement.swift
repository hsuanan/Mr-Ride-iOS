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
    
}

struct StationData{
    
    var station: String = ""
    var district: String = ""
    var location: String = ""
    var availableBikesNumber: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
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
    
    var stationArray = [StationData]()
    
    weak var delegate: JSONDataDelegation?
    
    
    
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
    
    func getBikeDataFromServer(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
            print("This is run on the background quene")
            
            let JWT = self.generateJWT()
            print ("This is JWT: \(JWT)")
            
            Alamofire.request(
                .GET,
                "http://data.taipei/youbike",
                encoding: .JSON,
                headers: ["Authorization": "Bearer \(JWT)"])
                .validate()
                .responseJSON {
                    response in
                    
                    guard let json = response.result.value as? [String: AnyObject]
                        
                        else{
                            print("Malformed data received from fetchAllRooms service")
                            
                            self.fetchStationCoreData() // 如果沒有拿到資料的話才從coreDatafetch資料
                            self.showStationCoreData() //test if get data
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.delegate?.didReceiveDataFromCoreData() //若不是從servers拿到資料,不會執行以下的didReceiveDataFromSerer
                                print("This is run on the main quene, after the previos code in outer block")
                            return}
                            print (response.response)
                            
                            return
                    }
//                    print("json:\(json)")
//                    self.cleanUpCoreData()
                    self.readJSONObject(json)
//                    self.SaveStationToCoreData()
//                    self.showStationCoreData() //test if get data
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.didReceiveDataFromServer() //透過delegate通知controller拿到資料
                        print("This is run on the main quene, after the previos code in outer block")
                    }
                    print (response.response)
            }
        }
    }
    
    //building a JWT with the builder pattern
    func generateJWT() -> String {
        return JWT.encode(.HS256("appworks")){ builder in
            builder.issuer = "Luffy Hsu"
            builder.expiration = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])
        }
    }
    
    func readJSONObject(json: [String: AnyObject]){
        
//        print("json:\(json)")
        guard
            let data = json["retVal"] //!["0001"]
                as? [String:AnyObject]
            else {
                
                print("readJSONObject step1 wrong")
                return }
        print("data:\(data)")
        
        for value in data.values {
            
//            print (value["sbi"] as! String)
            
            guard
            let station = value["snaen"],
            let district = value["sareaen"],
            let location = value["aren"],
            let availableBikesNumber = value["sbi"] as? String,
            let latitude = value["lat"] as? String,
            let longitude = value["lng"] as? String
            else { continue }
            
            stationArray.append(
                StationData(
                    station: String(station),
                    district: String(district),
                    location: String(location),
                    availableBikesNumber: Int(availableBikesNumber)!,
                    latitude: Double(latitude)!,
                    longitude: Double(longitude)!))
        
        }
        print ("stationArray:\(stationArray)")
    
    
    
//        for record in data {
//
//            let language = NSLocale.preferredLanguages()[0]
//            
//            let station: String
//            let district: String
//            let location: String
//            
//            if language == "zh-Hant-US" {  //zh-Hant-US 中文
//   
//                station = (record["sna"] as? String)!
//                district = (record["sarea"] as? String)!
//                location = (record["ar"] as? String)!
//                
//            } else {
//                station = (record["snaen"] as? String)!
//                district = (record["sareaen"] as? String)!
//                location = (record["aren"] as? String)!
//            }
//        
//            guard let sbi = record["sbi"] as? String,
//                let availableBikesNumber = Int(sbi),
//                let lat = record["lat"] as? String,
//                let latitude = Double(lat),
//                let lng = record["lng"] as? String,
//                let longitude = Double(lng)
//                else { continue }
//            
//            stationArray.append(
//                StationData(
//                    station: station,
//                    district: district,
//                    location: location,
//                    availableBikesNumber: availableBikesNumber,
//                    latitude: latitude,
//                    longitude: longitude))
//        }
//        
//        print("stationArray:\(stationArray)")
    }
    
    func SaveStationToCoreData(){
        /*
         initialize coreDataStation
         create station CoreData
         store data in the memory by using .save()
         */
        
        for dataInfo in stationArray {
            
            let entityStation = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: moc) as! Station
            
            entityStation.district = dataInfo.district
            entityStation.station = dataInfo.station
            entityStation.location = dataInfo.location
            entityStation.avaliableBikesNumber = dataInfo.availableBikesNumber
            entityStation.latitude = dataInfo.latitude
            entityStation.longitude = dataInfo.longitude
            
            do {
                try moc.save()
                print ("save station coredata")
                                print ("stationarray \(stationArray)")
                
            }catch{
                fatalError("Failure to save station coredata: \(error)")
            }
        }
    }
    
    func fetchStationCoreData(){
        
        let fetchStationRequest = NSFetchRequest(entityName: "Station")
        
        do {
            let fetchedStation = try moc.executeFetchRequest(fetchStationRequest) as! [Station]
            
            for eachFethcStationData in fetchedStation {
                guard
                    let station = eachFethcStationData.station,
                    let district = eachFethcStationData.district,
                    let location = eachFethcStationData.location,
                    let availableBikesNumber = eachFethcStationData.avaliableBikesNumber as? Int,
                    let latitude = eachFethcStationData.latitude as? Double,
                    let longitude = eachFethcStationData.longitude as? Double
                    else { continue }
                
                self.stationArray.append(
                    StationData(
                        station: station,
                        district: district,
                        location: location,
                        availableBikesNumber: availableBikesNumber,
                        latitude: latitude,
                        longitude: longitude))
            }
            print("Fetch data from coredata")
            print("fetched stationArray \(stationArray)")
            
        } catch {
            fatalError("Failed to fetch coredata: \(error)")
        }
    }

    
    func cleanUpCoreData(){
        let request = NSFetchRequest(entityName: "Station")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Station]
            
            for result in results {
                moc.deleteObject(result)
            }
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }catch {
            fatalError("Failure to cleanup coredata: \(error)")
        }
        print("clean up core data")
    }
    
    func showStationCoreData(){
        let request = NSFetchRequest(entityName: "Station")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Station]
            
            for result in results {
                print ("station name: \(result.station!) ")
                print ("availableBikeNumbers: \(result.avaliableBikesNumber!)")
            }
        }catch {
            fatalError("fail to fech data: \(error)")
        }
    }
    
    
}
