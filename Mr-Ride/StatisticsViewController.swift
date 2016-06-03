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
    
    

    
    let statisticsView = StatisticsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        
        
    }
    
//    func fetchRecordsCoreData(){
//        
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//
//        
//        let fetchRequest = NSFetchRequest(entityName: "Records")
//        fetchRequest.predicate = NSPredicate(format: "timestamp == %@", timestemp)
//        
//        do {
//            
//            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
////                statisticsView.distanceValue = Records
//            
//            
//        }
//            
//    }

    
    
}
