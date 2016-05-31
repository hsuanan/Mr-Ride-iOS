
//
//  HealthKitManager.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/31/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import Foundation
import HealthKit

class HealthKithManager {
    
    let healthKitStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success: Bool, error: NSError!) -> Void)!) {
        
        // State the health data type(s) we want to read from HealthKit
        let healthDataToRead = NSSet(array:[
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            ])
        
        // State the health data type(s) we want to write from HealthKit
        let healthDataToWrite = NSSet(array:[
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            ])
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
            return
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorizationToShareTypes(healthDataToWrite as? Set<HKSampleType>, readTypes: healthDataToRead as? Set<HKObjectType>) { (success, error) -> Void in
            if( completion != nil ) {
                completion(success:success, error:error)
            }
            
        }
    }
    func readProfile() -> ( Int?) {
//    func readProfile() -> ( age:Int?,  biologicalSex:HKBiologicalSexObject?) {
        
        var age: Int?

//         1. Request birthday and calculate age
        do {
            
            let birthDay = try healthKitStore.dateOfBirth()
            
            age = NSCalendar.currentCalendar().components(.Year, fromDate: birthDay, toDate: NSDate(), options: []).year
        
        } catch {
            
            print("Error reading Birthday: \(error)")
        }
        
        // 2. Read biological sex
        
//        do {
//            var biologicalSex = try healthKitStore.biologicalSex()
//            
//        } catch {
//            
//            print("Error reading Biological Sex: \(error)")
// 
//        }
            return (age)
//        return (age, biologicalSex)
    }
        
}