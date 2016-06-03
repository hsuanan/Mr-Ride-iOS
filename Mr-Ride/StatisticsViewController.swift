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

struct Locations{
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
}

class StatisticsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var coords = [Locations]()
    
    @IBOutlet var statisticsView: StatisticsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecordsCoreData()
    }
    
    
    
    //MARK: Core Data
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
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) //as! [Records]
            
            guard
                let distance = fetchedRecords.last?.valueForKey("distance"),
                let calories = fetchedRecords.last?.valueForKey("calories"),
                let duration = fetchedRecords.last?.valueForKey("duration"),
                let averageSpeed = fetchedRecords.last?.valueForKey("averageSpeed"),
                let location = fetchedRecords.last?.valueForKey("location")
                
                else { return }
            
            print("fetchedRecords - distance: \(distance), calories: \(calories), duration: \(duration)===========")
            print("FetchedLocation: \(location)")
            
            statisticsView.distanceValue.text = "\(distance) m"
            statisticsView.caloriesValue.text = "\(calories) kcal"
            statisticsView.totalTimeValue.text = "\(duration)"
            statisticsView.averageSpeedValue.text = "\(averageSpeed) km/hr"
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
        
        
//        let fetchLocationRequest = NSFetchRequest(entityName: "Location")
//        
//        do {
//            let fetchedLocations = try moc.executeRequest(fetchLocationRequest)
//            
//            guard
//                let latitude = fetchedLocations.valueForKey("latitude")as? Double,
//                let longitude = fetchedLocations.valueForKey("longitude")as? Double
//            
//                else {return}
//            
//            print("latitude: \(latitude), longitude: \(longitude)============================")
//            
//            
//        } catch {
//            let fetchError = error as NSError
//            print("fetchError:\(fetchError)")
//        }
//        
//        
//        
    }
}


//MARK: Map

//extension NewRecordViewController{
//
//    func showRoute() {
//
//        if (myLocations.count > 1) {
//            let sourceIndex = myLocations.count-1
//            let destinationIndex = myLocations.count-2
//            let oldCoord1 = myLocations[sourceIndex].coordinate
//            let oldCoord2 = myLocations[destinationIndex].coordinate
//            var coord = [oldCoord1, oldCoord2]
//            let polyline = MKPolyline(coordinates: &coord, count: coord.count)
//
//            if startIsOn == true {
//
//                self.mapView!.addOverlay(polyline)
//
//            } else {
//
//                return
//            }
//        }
//    }
//
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
//
//        if overlay is MKPolyline {
//
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.mrBubblegumColor()
//            polylineRenderer.lineWidth = 8
//            return polylineRenderer
//
//        }
//
//        return nil
//    }
//}




//        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()