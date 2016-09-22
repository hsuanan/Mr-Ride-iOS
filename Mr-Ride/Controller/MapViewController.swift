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
    var latitude: Double?
    var longitude: Double?
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, JSONDataDelegation, UIPickerViewDelegate, UIPickerViewDataSource {
    

    //MARK: DashBoardView property
    @IBOutlet weak var dashBoardView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var trafficTimeLabel: UILabel!
    
    //MARK: InputButton property
    @IBOutlet weak var lookForLabel: UILabel!
    @IBOutlet weak var inputButtonLabel: UILabel!
    @IBOutlet weak var inputButton: UIButton!
    @IBAction func inputButtonTapped(sender: UIButton) {
        print("inputButtonTapped")
        showPickerView()
    }
    let inputButtonLabelLayer = CAShapeLayer()
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    //MARK: BarButton
    @IBAction func barButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    //MARK: pickerView property
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    let pickOption = ["Ubike Station", "Toilet"]
    var rowSelected = 0
    
    let stationRecordModal = StationDataManager.sharedDataManager
    let toiletRecordModal = ToiletDataManager.sharedToiletDataManager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("MapPageViewDidLoad")
        
        setup()
        dashBoardViewSetUp()
        getLocationUpdate()
        mapView.delegate = self
        
        stationRecordModal.delegate = self
        stationRecordModal.getBikeDataFromServer()
        
        pickerView.hidden = true
        toolBar.hidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupInputButtonLabelLayer()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print ("______MapViewWillDisappear")
        
        locationManager.stopUpdatingLocation()
        
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
    }
    
    func setupInputButtonLabelLayer(){
        
        inputButtonLabelLayer.removeFromSuperlayer()
        
        let rRoundedPath = UIBezierPath(
            roundedRect: inputButtonLabel.bounds,
            byRoundingCorners:[.TopRight, .BottomRight],
            cornerRadii: CGSize(width: 4, height: 4))
        
        inputButtonLabelLayer.path = rRoundedPath.CGPath
        inputButtonLabel.layer.mask = inputButtonLabelLayer
    }
    
    func dashBoardViewSetUp() {

        dashBoardView.hidden = true
        dashBoardView.backgroundColor = UIColor.mrDarkSlateBlue90Color()
        dashBoardView.layer.cornerRadius = 10
        
        categoryLabel.textColor = UIColor.whiteColor()
        categoryLabel.font = UIFont.mrTextStyle4Font()
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.cornerRadius = 2
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.mrTextStyle71Font()
        letterSpacing(titleLabel.text!, letterSpacing: -0.6, label: titleLabel)
        addressLabel.textColor = UIColor.whiteColor()
        addressLabel.font = UIFont.mrTextStyle16Font()
        trafficTimeLabel.textColor = UIColor.whiteColor()
        trafficTimeLabel.font = UIFont.mrTextStyle4Font()
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    
    
    //MARK: PickerView
    
    func showPickerView() {
        
        pickerView.hidden = false
        toolBar.hidden = false
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.showsSelectionIndicator = true
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.delegate?.pickerView!(pickerView, didSelectRow: 0, inComponent: 0)
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.barTintColor = UIColor.mrBarColor()
        toolBar.translucent = false
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.cancelPickerTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let lookForTitle = UIBarButtonItem(title: "Look for", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        lookForTitle.tintColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.donePickerTapped))
        
        toolBar.setItems([cancelButton, spaceButton, lookForTitle, spaceButton, doneButton], animated: true)
        toolBar.userInteractionEnabled = true
    }
    
    func cancelPickerTapped() {
        
        pickerView.hidden = true
        toolBar.hidden = true
        
        rowSelected = pickOption.indexOf(inputButtonLabel.text!)!
        print ()
        updateAnnotation()
    }
    
    func donePickerTapped() {
        
        pickerView.hidden = true
        toolBar.hidden = true
        
        inputButtonLabel.text = pickOption[rowSelected]
        updateAnnotation()
    }
    
    
    //Mark: PickerView delegate
    
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
        
        rowSelected = row
        
        updateAnnotation()
    }
    
    
    //MARK: Map
    
    func getLocationUpdate() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.activityType = .Fitness
            //            locationManager.startUpdatingLocation()
            mapView.delegate = self
            mapView.showsUserLocation = true
            
        } else {
            
            print ("Need to Enable Location")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: \(error.localizedDescription)")
    }
    
    
    //MARK: Annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        var annotationId: String = ""
        switch rowSelected {
        case 0: annotationId = "station"
        case 1: annotationId = "toilet"
        default: annotationId = "reuseID"
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationId)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        // change subtitle font size
        let titleView = UILabel()
        titleView.font = titleView.font.fontWithSize(17)
        titleView.numberOfLines = 1
        titleView.text = annotation.subtitle!
        annotationView!.detailCalloutAccessoryView = titleView

        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        let pinImage = UIImage(named: customPointAnnotation.imageName!)
        let iconImageView = UIImageView(image: pinImage)
        iconImageView.image = iconImageView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        iconImageView.tintColor = UIColor.mrDarkSlateBlueColor()
        
        annotationView?.backgroundColor = UIColor.whiteColor()
        annotationView?.frame = CGRectMake(0, 0, 40, 40)
        
        annotationView?.layer.removeFromSuperlayer()
        annotationView?.layer.cornerRadius = annotationView!.frame.size.width / 2
        annotationView?.layer.shadowPath = UIBezierPath(ovalInRect: annotationView!.bounds).CGPath
        annotationView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        annotationView?.layer.shadowOpacity = 0.5
        annotationView?.layer.shadowRadius = 4

        annotationView?.addSubview(iconImageView)
        iconImageView.center = (annotationView?.center)!
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        if let annotation = view.annotation as? CustomPointAnnotation {
            
            let annotationLocation = CLLocation(latitude:annotation.latitude! , longitude: annotation.longitude!)
            
            let distance = annotationLocation.distanceFromLocation(currentLocation!)
            
            titleLabel.text = annotation.labelTitle
            addressLabel.text = annotation.address
            categoryLabel.text = " \((annotation.category)!) "
            trafficTimeLabel.text = "\(Int(distance)) m"
        }
        
        dashBoardView.hidden = false
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        view.backgroundColor = UIColor.whiteColor()
        dashBoardView.hidden = true
    }
    
    func updateAnnotation() {
        
        switch rowSelected {
        case 0:
            removeAnnotation()
            showStationAnnotation()
        case 1:
            removeAnnotation()
            showToiletAnnotation()
        default: showStationAnnotation()
        }
    }
    
    func showStationAnnotation() {
        
        for station in stationRecordModal.stationArray {
            
            let latitude = station.latitude
            let longitude = station.longitude
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.title = "\(station.availableBikesNumber) bikes available"
            annotation.subtitle = "\(station.availableDocks) docks available"
            annotation.imageName = "icon-station"
            annotation.labelTitle = station.station
            annotation.category = station.district
            annotation.address = station.location
            annotation.latitude = station.latitude
            annotation.longitude = station.longitude
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func showToiletAnnotation() {
        
        for toilet in toiletRecordModal.toiletArray {
            
            let latitude = toilet.latitude
            let longitude = toilet.longitude
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.title = toilet.title
            annotation.imageName = "icon-toilet"
            annotation.labelTitle = toilet.title
            annotation.category = toilet.category
            annotation.address = toilet.address
            annotation.latitude = toilet.latitude
            annotation.longitude = toilet.longitude
            mapView.addAnnotation(annotation)
        }
    }
    
    func removeAnnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    
    //MARK: Implement protocol
    
    func didReceiveDataFromServer() {
        showStationAnnotation()
    }
    
    func didReceiveDataFromCoreData() {
//        showStationAnnotation()
    }
}
