//
//  ToiletDataManagement.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/24/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON
import JWT


struct ToiletModel {
    
    var category: String = ""
    var title: String = ""
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}

protocol JSONParsable {
    
    associatedtype T
    
    func parse(json json: JSON) throws -> T
    
}

struct ToiletModelHelper {}

extension ToiletModelHelper: JSONParsable {
    
    struct JSONKey {
        static let category = "類別"
        static let title = "單位名稱"
        static let Latitude = "緯度"
        static let Longitude = "經度"
        static let Address = "地址"
    }
    enum JSONError: ErrorType { case MissingCategory, MissingLatitude, MissingLongitude, MissingTitle, MissingAddress }
    
    func parse(json json: JSON) throws -> ToiletModel {
        
        guard let category = json[JSONKey.category].string else {throw JSONError.MissingCategory}
        
        guard let title = json[JSONKey.title].string else { throw JSONError.MissingTitle }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let address = json[JSONKey.Address].string else { throw JSONError.MissingAddress }
        
        let toilet = ToiletModel(
            category: category,
            title: title,
            address: address,
            latitude: latitude,
            longitude: longitude)
        
        return toilet
    }
}


class ToiletDataManager {
    
    static let sharedToiletDataManager = ToiletDataManager()
    
    var toiletArray = [ToiletModel]()
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func getToiletDataFromServer() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
            
            Alamofire.request(
                .GET,
                "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            for (_, subJSON) in json["result"]["results"] {
                                do {
                                    let toilet = try ToiletModelHelper().parse(json: subJSON)
                                    self.toiletArray.append(toilet)
                                }
                                catch (let error){
                                    print ("Error: \(error)")
                                }
                            }
                            self.cleanUpToiletCoreData()
                            self.SaveToiletToCoreData()
                        }
                    case .Failure(let error):
                        print(error)
                        self.fetchToiletCoreData()
                        //self.showToiletCoreData()
                        print (response.response)
                        return
                    }
            }
        }
    }
    
    func generateJWT() -> String {
        return JWT.encode(.HS256("appworks")){ builder in
            builder.issuer = "Luffy Hsu"
            builder.expiration = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])
        }
    }
    
    func fetchToiletCoreData() {
        
        let fetchToiletRequest = NSFetchRequest(entityName: "Toilet")
        
        do {
            let fetchedToilet = try moc.executeFetchRequest(fetchToiletRequest) as! [Toilet]
            
            for eachFethcToiletData in fetchedToilet {
                guard
                    let Category = eachFethcToiletData.category,
                    let title = eachFethcToiletData.title,
                    let address = eachFethcToiletData.address,
                    let latitude = eachFethcToiletData.latitude as? Double,
                    let longitude = eachFethcToiletData.longitude as? Double
                    else { continue }
                
                self.toiletArray.append(
                    ToiletModel(
                        category: Category,
                        title: title,
                        address: address,
                        latitude: latitude,
                        longitude: longitude))
            }
            print("Fetch toilet data from coredata")
            
        } catch {
            fatalError("Failed to fetch toilet coredata: \(error)")
        }
    }
    
    func cleanUpToiletCoreData() {
        
        let request = NSFetchRequest(entityName: "Toilet")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Toilet]
            
            for result in results {
                moc.deleteObject(result)
            }
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }catch {
            fatalError("Failure to cleanup toilet coredata: \(error)")
        }
    }
    
    func SaveToiletToCoreData() {
        
        
        for dataInfo in toiletArray {
            
            let entityToilet = NSEntityDescription.insertNewObjectForEntityForName("Toilet", inManagedObjectContext: moc) as! Toilet
            
            entityToilet.category = dataInfo.category
            entityToilet.title = dataInfo.title
            entityToilet.address = dataInfo.address
            entityToilet.latitude = dataInfo.latitude
            entityToilet.longitude = dataInfo.longitude
            
            do {
                try moc.save()
                
            } catch {
                fatalError("Failure to save toilet coredata: \(error)")
            }
        }
    }
    
    func showToiletCoreData(){
        let request = NSFetchRequest(entityName: "Toilet")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Toilet]
            
            for result in results {
                print ("Toilet name: \(result.title!) ")
            }
        } catch {
            fatalError("fail to fech data: \(error)")
        }
    }
}