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
    
    var locationList = [Locations]()
    var coordToUse = [CLLocationCoordinate2D]()
    
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
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
            
            guard let lastRecord = fetchedRecords.last
                
                else {
                    print("[StaticsViewController](fetchRecordsCoreData) can't get last record");
                    return }
            
            guard
                let distance = lastRecord.distance,
                let calories = lastRecord.calories,
                let duration = lastRecord.duration,
                let averageSpeed = lastRecord.averageSpeed,
                let locationSet = lastRecord.location
                
                else {
                    print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
                    return }
            
            guard let loctionArray = locationSet.array as? [Location]
                
                else {
                    print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
                    return }
            
            for location in loctionArray {
                
//                print("latitude:\(location.latitude) longitude:\(location.longitude)")
                
                guard
                    let latitude = location.latitude as? Double,
                    let longitude = location.longitude as? Double
                    
                    else {continue}
                locationList.append(
                    Locations(latitude: latitude, longitude: longitude))

            }
            
//            print("locationList: \(locationList)")
            
            statisticsView.distanceValue.text = "\(distance) m"
            statisticsView.caloriesValue.text = "\(calories) kcal"
            statisticsView.totalTimeValue.text = "\(duration)"
            statisticsView.averageSpeedValue.text = "\(averageSpeed) km/hr"
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
    }
    
    
    
    //    MARK: Map
    func showRoute() {
        
        for location in locationList {
            
            coordToUse.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }

        let polyline = MKPolyline(coordinates: &coordToUse, count: coordToUse.count)
        
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