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
    var imageName: String?
    var labelTitle: String?
    var address: String?
    var category: String?
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, JSONDataDelegation, JSONToiletDataDelegation, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dashBoardView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var trafficTimeLabel: UILabel!
    
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
    
    var annotationView: MKAnnotationView?
    var iconImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        dashBoardViewSetUp()
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
    
    func dashBoardViewSetUp() {
        
        dashBoardView.hidden = true
        dashBoardView.backgroundColor = UIColor.mrDarkSlateBlue90Color()
        
        categoryLabel.textColor = UIColor.whiteColor()
        categoryLabel.font = UIFont.mrTextStyle4Font()
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.cornerRadius = 2
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.mrTextStyle71Font()
        addressLabel.textColor = UIColor.whiteColor()
        addressLabel.font = UIFont.mrTextStyle16Font()
        trafficTimeLabel.textColor = UIColor.whiteColor()
        trafficTimeLabel.font = UIFont.mrTextStyle4Font()
        
        
        
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
        
        switch row {
        case 0:
            removeAnnotation()
            showStationAnnotation()
        case 1:
            removeAnnotation()
            showToiletAnnotation()
        default: showStationAnnotation()
        }
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
    
    
    //MARK: Annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let annotationId = "reuseID"
        annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationId)
        //如果地標已經建立,直接顯示該地標,否則就建立一個可自訂圖示的新地標
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        let pinImage = UIImage(named: cpa.imageName!)
        iconImageView = UIImageView(image: pinImage)
        
        //        annotationView?.image = pinImage
        annotationView?.backgroundColor = UIColor.whiteColor()
        annotationView?.frame = CGRectMake(0, 0, 40, 40)
        annotationView?.layer.cornerRadius = annotationView!.frame.size.width / 2
        
        annotationView?.addSubview(iconImageView!)
        iconImageView?.center = (annotationView?.center)!
        
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        print("didSelectAnnotationView")
        view.backgroundColor = UIColor.mrLightblueColor()
        
        if let annotation = view.annotation as? CustomPointAnnotation {
            
            titleLabel.text = annotation.labelTitle
            addressLabel.text = annotation.address
            categoryLabel.text = annotation.category
        }
        

        
        dashBoardView.hidden = false
        
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("didDeselectAnnotationView")
        
        view.backgroundColor = UIColor.whiteColor()
        dashBoardView.hidden = true
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
            annotation.labelTitle = station.station
            annotation.category = station.district
            annotation.address = station.location
            
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
            annotation.labelTitle = toilet.title
            annotation.address = toilet.address
            mapView.addAnnotation(annotation)

        }
        
        print("showToiletAnnotation")
    }
    
    func removeAnnotation() {
        iconImageView?.removeFromSuperview()
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
