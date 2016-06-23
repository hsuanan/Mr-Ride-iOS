//
//  MapViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/1/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, JSONDataDelegation {
    
    @IBOutlet weak var lookForLabel: UILabel!
    
    @IBOutlet weak var inputButtonLabel: UILabel!
    
    @IBOutlet weak var inputButton: UIButton!
    
    @IBAction func inputButtonTapped(sender: UIButton) {
        
        showPickerView()
        
    }
 
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func barButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }
    
    let recordModal = DataManager.sharedDataManager
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getLocationUpdate()
        mapView.delegate = self
        
        recordModal.getBikeDataFromServer()
        recordModal.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print ("______MapViewWillDisappear")
        
        locationManager.stopUpdatingLocation()
        print("Stop Updating Location")
        
        mapView = nil
        
    }
    
    deinit {
        
        print("Leave Map Page")
    }
    
    
    
    // MARK: Setup
    
    func setup() {
        
        view.backgroundColor = UIColor.mrLightblueColor()
        mapView.layer.cornerRadius = 10.0
        
        lookForLabel.backgroundColor = UIColor.whiteColor()
        lookForLabel.textColor = UIColor.mrDarkSlateBlueColor()
        
        let lookForLabelLayer = CAShapeLayer()
        let roundedPath = UIBezierPath(
            roundedRect: lookForLabel.bounds,
            byRoundingCorners: [ .TopLeft, .BottomLeft],
            cornerRadii: CGSize(width: 4, height: 4)
        )
        lookForLabelLayer.path = roundedPath.CGPath
        lookForLabel.layer.mask = lookForLabelLayer
        
        
        inputButtonLabel.backgroundColor = UIColor.whiteColor()
        inputButtonLabel.font = UIFont.mrTextStyle10Font()
        inputButtonLabel.textColor = UIColor.mrDarkSlateBlueColor()
        inputButton.backgroundColor = UIColor.clearColor()
        
        let inputButtonLabelLayer = CAShapeLayer()
        let rRoundedPath = UIBezierPath(
            roundedRect: inputButtonLabel.bounds,
            byRoundingCorners:[.TopRight, .BottomRight, .TopLeft, .BottomLeft],
            cornerRadii: CGSize(width: 4, height: 4))
        
        inputButtonLabelLayer.path = rRoundedPath.CGPath
        inputButtonLabel.layer.mask = inputButtonLabelLayer
        
    }
    
    func showPickerView() {
        
        let pickerView = UIPickerView(frame: CGRectMake(0, 406, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePicker")
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "canclePicker")
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
        
        view.addSubview(pickerView)

    }
    
    //MARK: Map
    
    func getLocationUpdate() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10 // update every 10 meters
            locationManager.activityType = .Fitness
//            locationManager.startUpdatingLocation()
            mapView!.delegate = self
            mapView!.showsUserLocation = true
            
        } else {
            
            print ("Need to Enable Location")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView!.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: \(error.localizedDescription)")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationId = "Station"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            annotationView?.canShowCallout = true
            
            // Resize image
            let pinImage = UIImage(named: "icon-station")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            annotationView?.backgroundColor = UIColor.whiteColor()
            annotationView!.layer.cornerRadius = annotationView!.frame.size.width / 2
            
        }
        else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    
    func showAnnotation() {
        
//        print("recordModal.stationArray:\(recordModal.stationArray)")
        
        for station in recordModal.stationArray {
            
            let latitude = station.latitude
            let longitude = station.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location  // pin a marker
            annotation.title = "\(station.availableBikesNumber) bikes left"
            mapView.addAnnotation(annotation)
        }
        
    }
    

    // Mark: implement protocol
    
    func didReceiveDataFromServer() {
        print("didReceiveDataFromServer")
        showAnnotation()
    }
    
    func didReceiveDataFromCoreData() {
        print("didReceiveDataFromCoreData")
    }
    
    
}
