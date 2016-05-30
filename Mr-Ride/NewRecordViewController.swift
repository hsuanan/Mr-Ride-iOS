//
//  NewRecordViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/23/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class NewRecordViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceTitle: UILabel!

    @IBOutlet weak var distanceValue: UILabel!
    
    @IBOutlet weak var averageSpeedTitle: UILabel!
    
    @IBOutlet weak var averageSpeedValue: UILabel!
    
    @IBOutlet weak var caloriesTitle: UILabel!
    
    @IBOutlet weak var caloriesValue: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var playPauseButtonView: UIView!
    
    @IBAction func playPauseButtonPressed(sender: UIButton) {
        
        animatedWithDuration()
    }
  
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var myLocations = [CLLocation]()
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupDistance()
        setupAverageSpeed()
        setupCalories()
        setupTimeLabel()
        setupMap()
        drawCircle()
        
        setupPlayButton()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        
        //setup Map
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.activityType = .Fitness //??
        locationManager.distanceFilter = 10.0
        
        mapView.showsUserLocation = true
        //        mapView.userTrackingMode = MKUserTrackingMode.Follow
        
//        locationManager.stopUpdatingLocation()
        
    }
    
    //resize layers based on the view's new frame
    override func viewDidLayoutSubviews() {
        
        gradient.frame = self.view.bounds
    }


    
    
// MARK: Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last
        //didUpdateLocations hase been call over and over agian after we called startUpdatingLocation until we call stopUpdatingLocation, so "last" get the most current one
        myLocations.append(currentLocation!)
        
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        
        // map zoom in
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.005, 0.005))
        // map zoom in animation
        mapView.setRegion(region, animated: true)
        
        // Show Route
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count-1
            let destinationIndex = myLocations.count-2
            let oldCoord1 = myLocations[sourceIndex].coordinate
            let oldCoord2 = myLocations[destinationIndex].coordinate
            var coord = [oldCoord1, oldCoord2]
            let polyline = MKPolyline(coordinates: &coord, count: coord.count)
            self.mapView.addOverlay(polyline)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: \(error.localizedDescription)")
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.mrBubblegumColor()
            polylineRenderer.lineWidth = 10
            return polylineRenderer
            
        }
        return nil
    }
    
    // MARK: Setup
    
    func setupBackground() {
        
        view.backgroundColor = UIColor.mrWaterBlueColor()
        
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        gradient.frame = self.view.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    func setupDistance() {
        distanceTitle.font = UIFont.mrTextStyle16Font()
        distanceTitle.textColor = UIColor.mrWhiteColor()
        distanceTitle.text = "Distance"
        letterSpacing(distanceTitle.text!, letterSpacing: 0.3, label: distanceTitle)

        
        distanceValue.font = UIFont.mrTextStyle15Font()
        distanceValue.textColor = UIColor.mrWhiteColor()
        distanceValue.text = "109 m"
        letterSpacing(distanceValue.text!, letterSpacing: 0.7, label: distanceValue)
    
    }
    
    func setupAverageSpeed() {
        
        averageSpeedTitle.font = UIFont.mrTextStyle16Font()
        averageSpeedTitle.textColor = UIColor.mrWhiteColor()
        averageSpeedValue.text = "AverageSpeed"
        letterSpacing(averageSpeedTitle.text!, letterSpacing: 0.3, label: averageSpeedTitle)

        
        averageSpeedValue.font = UIFont.mrTextStyle15Font()
        averageSpeedValue.textColor = UIColor.mrWhiteColor()
        averageSpeedValue.text = "12 km/h"
        letterSpacing(averageSpeedValue.text!, letterSpacing: 0.7, label: averageSpeedValue)
    }
    
    func setupCalories() {
        
        caloriesTitle.font = UIFont.mrTextStyle16Font()
        caloriesTitle.textColor = UIColor.mrWhiteColor()
        caloriesTitle.text = "Calories"
        letterSpacing(caloriesTitle.text!, letterSpacing: 0.3, label: caloriesTitle)
        
        
        caloriesValue.font = UIFont.mrTextStyle15Font()
        caloriesValue.textColor = UIColor.mrWhiteColor()
        caloriesValue.text = "910 kcal"
        letterSpacing(caloriesValue.text!, letterSpacing: 0.7, label: caloriesValue)

    }
    
    func setupTimeLabel() {
        timeLabel.font = UIFont.mrTextStyle9Font()
        timeLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(timeLabel.text!, letterSpacing: 0.7, label: timeLabel)
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:MM:SS"

    }
    
    func setupMap(){
        mapView.layer.cornerRadius = 10.0
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    
    func drawCircle() {
        
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            roundedRect: circleView.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight, .TopLeft, .TopRight],
            cornerRadii: CGSize(width: 80, height: 80))
        
        circleLayer.frame = circleView.bounds
        circleLayer.path = circlePath.CGPath
        circleLayer.lineWidth = 4
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        
        circleView.layer.addSublayer(circleLayer)
    }
    
    func setupPlayButton(){
        
        playPauseButtonView.layer.cornerRadius = playPauseButtonView.frame.size.width / 2
        playPauseButtonView.backgroundColor = UIColor.redColor()
    }
    
    func animatedWithDuration(){
        
        UIView.animateWithDuration(
            0.0 , animations: {
                self.playPauseButtonView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.playPauseButtonView.layer.cornerRadius = 4
        })
    }
    
    
    
    

    
    
    
    
    
}
