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
    
//    var coords = [CLLocation]()
    var locationList = [Locations]()
    var coordToUse = [CLLocationCoordinate2D]()
    
    var distance = 0.0
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var statisticsView: StatisticsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecordsCoreData()
        statisticsView.mapView.delegate = self
        
        showRoute()
    }
    
    
    
    
    //MARK: Core Data
    func fetchRecordsCoreData(){
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        let searchDate = NSDate(timeIntervalSinceNow: -60)
//        fetchRequest.predicate = NSPredicate(format: "timestamp > %@", searchDate)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
            
//                        print ("fetchRecords\(fetchedRecords)==============")
            
            guard
                let distance = fetchedRecords.last?.valueForKey("distance"),
                let calories = fetchedRecords.last?.valueForKey("calories"),
                let duration = fetchedRecords.last?.valueForKey("duration"),
                let averageSpeed = fetchedRecords.last?.valueForKey("averageSpeed"),
                let locations = fetchedRecords.last?.valueForKey("location")
                else { return }
            
            
            print("fetchedRecords - distance: \(distance), calories: \(calories), duration: \(duration)===========")
            print("locations : \(locations)")
            
            
            statisticsView.distanceValue.text = "\(distance) m"
            statisticsView.caloriesValue.text = "\(calories) kcal"
            statisticsView.totalTimeValue.text = "\(duration)"
            statisticsView.averageSpeedValue.text = "\(averageSpeed) km/hr"
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
        
        
        let fetchLocationRequest = NSFetchRequest(entityName: "Location")
        fetchLocationRequest.predicate = NSPredicate(format: "timeStamp > %@", searchDate)
        fetchLocationRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        
        do {
            let fetchedLocations = try moc.executeFetchRequest(fetchLocationRequest) as! [Location]
            
            for coordinate in fetchedLocations {
                
                guard
                    let latitude = coordinate.latitude as? Double,
                    let longitude = coordinate.longitude as? Double
                    else {continue}
                
                self.locationList.append(
                    Locations(
                        latitude: latitude,
                        longitude: longitude))
            }
            
            print("=============locationList : \(locationList)=============")
            
            
            for location in locationList {
                coordToUse.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                        }
                print("===========coords: \(coordToUse)==============")
            
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
    }
    
    
    
//    MARK: Map
    func showRoute() {
        
        let polyline = MKPolyline(coordinates: &coordToUse, count: locationList.count)
        
        statisticsView.mapView.addOverlay(polyline)
        statisticsView.mapView.zoomToPolyLine(polyline, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.mrBubblegumColor()
            polylineRenderer.lineWidth = 8
            return polylineRenderer
        }
        return nil
    }
    
}

extension MKMapView {
    
    private func zoomToPolyLine(polyline: MKPolyline, animated: Bool) {
        
        setVisibleMapRect(
            polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0),
            animated: animated)
    }
}






//        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()