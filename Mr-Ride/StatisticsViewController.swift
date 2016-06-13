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
    
//    var locationList = [Locations]()
    var coordToUse = [CLLocationCoordinate2D]()
    
    let locationManager = CLLocationManager()
    
    let recordModel = DataManager.sharedDataManager
    
    var records: RecordsModel?
    
    var isFromHistory = false
    
    @IBOutlet var statisticsView: StatisticsView!
    
    @IBAction func BackOrDoneButtonTapped(sender: AnyObject) {
        
        if isFromHistory == true {
            print("BackButtonTapped")
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            print("DoneButtonTapped")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchRecordsCoreData()
        recordModel.fetchRecordsCoreData()
        statisticsView.mapView.delegate = self
        
        showRoute()
        
        if isFromHistory == false {
            navigationItem.leftBarButtonItem?.title = "Done"
            print("isFromHistory is false")
            uploadNewRecord()
            
        } else {
            navigationItem.leftBarButtonItem?.title = "< Back"
            print("isFromHistory is true")
            uploadRecordFromHistoryPage()
        }
        
    }
    
    
//    //MARK: Core Data
//    func fetchRecordsCoreData(){
//
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Records")
//        
//        do {
//            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
//            
//            guard let lastRecord = fetchedRecords.last
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get last record");
//                    return }
//            
//            guard
//                let timestemp = lastRecord.timestamp,
//                let distance = lastRecord.distance,
//                let calories = lastRecord.calories,
//                let duration = lastRecord.duration as? Double,
//                let averageSpeed = lastRecord.averageSpeed,
//                let locationSet = lastRecord.location
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
//                    return }
//            
//            guard let loctionArray = locationSet.array as? [Location]
//                
//                else {
//                    print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
//                    return }
//            
//            for location in loctionArray {
//                
////                print("latitude:\(location.latitude) longitude:\(location.longitude)")
//                
//                guard
//                    let latitude = location.latitude as? Double,
//                    let longitude = location.longitude as? Double
//                    
//                    else {continue}
//                locationList.append(
//                    Locations(latitude: latitude, longitude: longitude))
//
//            }
//            
//            print("locationList: \(locationList)")
//         
//
//            statisticsView.distanceValue.text = "\(Int(duration)) m"
//            statisticsView.caloriesValue.text = "\(Int(calories)) kcal"
//            statisticsView.totalTimeValue.text = "\(timerString(duration))"
//            statisticsView.averageSpeedValue.text = "\(Int(averageSpeed)) km/hr"
//            navigationItem.title = "\(dateString(timestemp))"
//    
//        } catch {
//            let fetchError = error as NSError
//            print("fetchError:\(fetchError)")
//        }
//    }
    
    func uploadNewRecord() {
        
        let savedData = recordModel.saveRecords.last

        if savedData != nil {
            statisticsView.distanceValue.text = "\(Int(savedData!.distance)) m"
            statisticsView.caloriesValue.text = "\(Int(savedData!.calories)) kcal"
            statisticsView.totalTimeValue.text = "\(timerString(savedData!.duration))"
            statisticsView.averageSpeedValue.text = "\(Int(savedData!.averageSpeed)) km/hr"
            navigationItem.title = "\(dateString(savedData!.timestamp))"
            
        } else {
            print ("recordModel.saveRecords.last is nil");
            return
        }
    }
    
    func uploadRecordFromHistoryPage() {
        
        if records != nil {
        
        statisticsView.distanceValue.text = "\(Int(records!.distance)) m"
        statisticsView.caloriesValue.text = "\(Int(records!.calories)) kcal"
        statisticsView.totalTimeValue.text = "\(timerString((records?.duration)!))"
        statisticsView.averageSpeedValue.text = "\(Int((records?.averageSpeed)!)) km/hr"
        navigationItem.title = "\(dateString((records?.timestamp)!))"
        
        } else {
            print("records is nil");
            return }

    }
    func dateString(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd"
        return dateFormatter.stringFromDate(date)
        
    }
    
    func numberString(number: Double ) -> NSString {
        
        return NSString(format:"%.2f",number)
    }
    
    
    func timerString(time: Double) -> String {
        
        let hours = Int(time) / (100 * 60 * 60)
        let minutes = Int(time) / (100 * 60) % 60
        let seconds = Int(time) / 100 % 60
        let secondsFrec = Int(time) % 100
        return String(format:"%02i:%02i:%02i.%02i", hours, minutes, seconds, secondsFrec)
    }

    
    //    MARK: Map
    func showRoute() {
//        for location in locationList {
        
        if isFromHistory == false {
            
            let savedData = recordModel.saveRecords.last
            
            for location in savedData!.location {
                
                coordToUse.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
        } else {
            
            for location in (records?.location)! {
                
                coordToUse.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
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