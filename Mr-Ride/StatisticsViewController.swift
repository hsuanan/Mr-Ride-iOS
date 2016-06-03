//
//  StatisticsViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/23/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class StatisticsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet var statisticsView: StatisticsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

      
        fetchRecordsCoreData()
        
        
        
    }
    
    func fetchRecordsCoreData(){
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        
//        let timestamp = NSDate().timeIntervalSince1970
//        
//        fetchRequest.predicate = NSPredicate(format: "timestamp == %@", timestamp)
//        
//        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
        
            print("fetchedRecords:\(fetchedRecords)")
            
            print("distance = \(fetchedRecords.last?.valueForKey("distance"))")
            print("calories = \(fetchedRecords.last?.valueForKey("calories"))")
            print("duration =\(fetchedRecords.last?.valueForKey("duration"))")
            
            
            guard
                let distance = fetchedRecords.last?.valueForKey("distance"),
                let calories = fetchedRecords.last?.valueForKey("calories"),
                let duration = fetchedRecords.last?.valueForKey("duration"),
                let averageSpeed = fetchedRecords.last?.valueForKey("averageSpeed")
            
            else { return }
        
            print("distance: \(distance), calories: \(calories), duration: \(duration)")
            
            statisticsView.distanceValue.text = "\(distance) m"
            statisticsView.caloriesValue.text = "\(calories) kcal"
            statisticsView.totalTimeValue.text = "\(duration)"
            statisticsView.averageSpeedValue.text = "\(averageSpeed) km/hr"
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
//
    }

    
}



//        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()