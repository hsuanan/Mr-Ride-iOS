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

protocol StatisticsViewControllerDelegate: class {
    
    func didDismiss2()
    
}

class StatisticsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var coordToUse = [CLLocationCoordinate2D]()
    
    let locationManager = CLLocationManager()
    
    let recordModel = DataManager.sharedDataManager
    
    var timestamp: NSDate?
    var distance: Double?
    var averageSpeed: Double?
    var calories: Double?
    var duration: Double?
    var locations: [Locations]=[]
    
    var isFromHistory = false
    
    weak var delegate: StatisticsViewControllerDelegate?
        
    @IBOutlet var statisticsView: StatisticsView!
    
    @IBAction func BackOrDoneButtonTapped(sender: AnyObject) {
        
        if isFromHistory == true {
            print("BackButtonTapped")
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            print("DoneButtonTapped")
            
            delegate?.didDismiss2()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("____StatisticsViewDidLoad")
        
        //        fetchRecordsCoreData()
        recordModel.fetchRecordsCoreData()
        statisticsView.mapView.delegate = self
        
        uploadRecord()
        showRoute()
        
        if isFromHistory == false {
            navigationItem.leftBarButtonItem?.title = "Done"
            print("isFromHistory is false")
            
        } else {
            navigationItem.leftBarButtonItem?.title = "< Back"
            print("isFromHistory is true")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("____StatisticsViewWillAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("____StatisticViewWillDisappear")
        
    }
    
    deinit {
        
        print("____Leave Statistics Page")
    }

    
    
    func uploadRecord() {
        
        statisticsView.distanceValue.text = "\(Int(distance!)) m"
        statisticsView.caloriesValue.text = "\(Int(calories!)) kcal"
        statisticsView.totalTimeValue.text = "\(timerString(duration!))"
        statisticsView.averageSpeedValue.text = "\(Int(averageSpeed!)) km/hr"
        navigationItem.title = "\(dateString(timestamp!))"
        
    }

    //MARK: Helper Method
    
    func dateString(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
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

        for location in locations {
            
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

