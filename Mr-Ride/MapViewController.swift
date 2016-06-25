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

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, JSONDataDelegation, JSONToiletDataDelegation, UIPickerViewDelegate, UIPickerViewDataSource {
    

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
    let toiletRecordModal = ToiletDataManager.sharedToiletDataManager
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var pickOption = ["UBike Station", "Toilet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getLocationUpdate()
        mapView.delegate = self
        
        recordModal.delegate = self
        recordModal.getBikeDataFromServer()
        
        
        toiletRecordModal.delegate = self
        toiletRecordModal.getToiletDataFromServer()
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
        inputButtonLabel.text = "Ubike Station"
        
        inputButton.backgroundColor = UIColor.clearColor()
        
        let inputButtonLabelLayer = CAShapeLayer()
        let rRoundedPath = UIBezierPath(
            roundedRect: inputButtonLabel.bounds,
            byRoundingCorners:[.TopRight, .BottomRight, .TopLeft, .BottomLeft],
            cornerRadii: CGSize(width: 4, height: 4))
        
        inputButtonLabelLayer.path = rRoundedPath.CGPath
        inputButtonLabel.layer.mask = inputButtonLabelLayer
        
    }
    
    //MARK: PickerView
    
    func showPickerView() {
//        pickerView = UIPickerView()
        pickerView = UIPickerView(frame: CGRectMake(0, 455, view.frame.width, 217))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.showsSelectionIndicator = true
        
        
        toolBar = UIToolbar(frame:CGRectMake(0, 411, view.frame.width, 44))
//        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.barTintColor = UIColor.mrBarColor()
        toolBar.translucent = false
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.cancelPickerTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        spaceButton.title = "look For"
        let lookFor = UIBarButtonItem(title: "Look for", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        lookFor.tintColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.donePickerTapped))

        toolBar.setItems([cancelButton, spaceButton, lookFor, spaceButton, doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
//        pickerView.addSubview(toolBar)
        view.addSubview(toolBar)
        view.addSubview(pickerView)

    }
    
    func cancelPickerTapped() {
        
        pickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        print("cancelPickerTapped")
        
    }
    
    func donePickerTapped() {
        
        pickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        print("donePickerTapped")
        
        if inputButtonLabel.text == "Ubike Station" {
            removeAnnotation()
            showStationAnnotation()
            
            
        } else {
            removeAnnotation()
            showToiletAnnotation()
        }
    
    }
    
    
    //MarkL pickerView delegate

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputButtonLabel.text = pickOption[row]
        print("didSelectRow:\(row)")
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
        //如果地標已經建立,直接顯示該地標,否則就建立一個可自訂圖示的新地標
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
            
//            if inputButtonLabel.text == "Ubike Station" {
//                
//                annotationView?.image = resizedImage
//                
//            } else if inputButtonLabel.text == "Toilet" {
//
//                annotationView?.image = UIImage(named: "icon-toilet")
//                
//            } else {
//                print ("annotation image error")
//            }
            
//            annotationView?.image = resizedImage
            
            let cpa = annotation as! CustomPointAnnotation
             annotationView!.image = UIImage(named: cpa.imageName)
            annotationView?.backgroundColor = UIColor.whiteColor()
            annotationView!.layer.cornerRadius = annotationView!.frame.size.width / 2
            
        }
        else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    func showStationAnnotation() {
        
        for station in recordModal.stationArray {
            
            let latitude = station.latitude
            let longitude = station.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = CustomPointAnnotation()
//            let annotation = MKPointAnnotation()
            annotation.coordinate = location  // pin a marker
            annotation.title = "\(station.availableBikesNumber) bikes left"
            annotation.imageName = "icon-station"
            mapView.addAnnotation(annotation)
        }
        print("showStationAnnotation")
    }
    
    func showToiletAnnotation() {
       
        for toilet in toiletRecordModal.toiletArray {
            
            let latitude = toilet.latitude
            let longitude = toilet.longitude
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = CustomPointAnnotation()
//            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = toilet.title
            annotation.imageName = "icon-toilet"
            mapView.addAnnotation(annotation)
        }
        
        print("showToiletAnnotation")
    }
    
    func removeAnnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        print("removeAnnotation")
    }
    
    
    
    // Mark: implement protocol
    
    func didReceiveDataFromServer() {
        print("didReceiveDataFromServer")
        
        
        showStationAnnotation()
        
    }
    
    func didReceiveDataFromCoreData() {
        print("didReceiveDataFromCoreData")
        showStationAnnotation()
    }
//    
    func didReceiveToiletDataFromServer() {
        print("didReceiveToiletDataFromServer")
//        showToiletAnnotation()
    }
    
    func didReceiveToiletDataFromCoreData() {
        print("didReceiveToiletDataFromServer")
//        showToiletAnnotation()
    }
    
}
