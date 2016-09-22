//
//  StationDataManagement.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 7/11/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import CoreLocation


protocol JSONDataDelegation: class {
    func didReceiveDataFromServer()
}

struct StationModel{
    
    var station: String = ""
    var district: String = ""
    var location: String = ""
    var availableBikesNumber: Int = 0
    var availableDocks: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}


class StationDataManager {
    
    static let sharedDataManager = StationDataManager()
    
    var stationArray = [StationModel]()
    
    weak var delegate: JSONDataDelegation?
    
    
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
                            print (response.response)
                            return
                    }
                    self.stationArray.removeAll()
                    self.readJSONObject(json)
                    
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
                let availableDocks = value["bemp"] as? String,
                let latitude = value["lat"] as? String,
                let longitude = value["lng"] as? String
                else { print ("transJSONtype error")
                    continue }
            
            stationArray.append(
                StationModel(
                    station: station,
                    district: district,
                    location: location,
                    availableBikesNumber: Int(availableBikesNumber)!,
                    availableDocks: Int(availableDocks)!,
                    latitude: Double(latitude)!,
                    longitude: Double(longitude)!))
        }
    }
}