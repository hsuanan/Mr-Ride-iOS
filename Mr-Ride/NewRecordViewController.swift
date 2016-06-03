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
import CoreData

class NewRecordViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView?
    
    @IBOutlet weak var distanceTitle: UILabel!
    
    @IBOutlet weak var distanceValue: UILabel!
    
    @IBOutlet weak var currentSpeedTitle: UILabel!
    
    @IBOutlet weak var currentSpeedValue: UILabel!
    
    @IBOutlet weak var caloriesTitle: UILabel!
    
    @IBOutlet weak var caloriesValue: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var playPauseButtonView: UIView!
    
    @IBAction func playPauseButtonPressed(sender: UIButton) {
        
        if startIsOn == false {
            
            
            animateFromCircleToSquare()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            
            startIsOn = true
            
            print ("StartIsOn:\(startIsOn)")
            
        } else {
            
            animateFromSqareToCircle()
            
            timer.invalidate()
            
            startIsOn = false
            
            print ("StartIsOn:\(startIsOn)")
            
        }
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        saveRecordsToCoreData()
        print ("finishButtonTapped")
        
        performSegueWithIdentifier("showStatisticsPage", sender: sender)
    }
    
    var startIsOn = false
    
    var timeInterval = 0.0
    var timer = NSTimer()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var myLocations = [CLLocation]()
    var startLocation: CLLocation?
    var lastLocation: CLLocation?
    var traveledDistance = 0.0
    var averageSpeed = 0.0
    var currentSpeed = 0.0
    var caloriesBurned = 0
    let date = NSDate()
    
    
    var weight = 0.0
    
    
    
    
    let gradient = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("viewDidLoad")
        
        setupBackground()
        setupDistance()
        setupAverageSpeed()
        setupCalories()
        setupTimeLabel()
        setupMap()
        drawCircle()
        setupPlayButton()
        
        getLocationUpdate()
        
        
        
        
    }
    
    //resize layers based on the view's new frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = self.view.bounds
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        print("viewDidAppear")
        

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
        locationManager.stopUpdatingLocation()
        print("Stop Updating Location")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView = nil
        // avoid mapView佔記憶體
    }
        
    
    // MARK: Timer
    
    func updateTimer(){
        
        timeInterval += 1.0
        timerLabel.text = "\(timerString(timeInterval))"
        
    }
    
    func timerString(time: NSTimeInterval) -> String {
        
        let hours = Int(time) / (100*60*60)
        let minutes = Int(time) / (100 * 60) % 60
        let seconds = Int(time) / 100 % 60
        let secondsFrec = Int(time) % 100
        return String(format:"%02i:%02i:%02i.%02i", hours, minutes, seconds, secondsFrec)
        
    }
    
    
    // MARK: Location
    
    func getLocationUpdate() {
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.distanceFilter = 10 // update every 10 meters
            
            locationManager.activityType = .Fitness
            
            locationManager.startUpdatingLocation()
            
            mapView!.delegate = self
            mapView!.showsUserLocation = true
            
        } else {
            
            print ("Need to Enable Location")
            
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //rember to setup timestamp: 5 min to avoid get other location from last time
        
        currentLocation = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        
        // map zoom in
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.005, 0.005))
        mapView!.setRegion(region, animated: true)
        
        
        // Distance, Speed, Calories
        
        if startLocation == nil {
            
            startLocation = locations.last
            
        } else {
            
            startLocation = myLocations.last
        }
        
        let lastLocation = locations.last
        
        let distance = startLocation?.distanceFromLocation(lastLocation!)
        
        
        if startIsOn == true {
            
            traveledDistance += distance!
            
            averageSpeed = (traveledDistance/1000) / (timeInterval/(100*60*60))
            
            distanceValue.text = ("\(Int(traveledDistance)) m")
            
            let currentSpeed = Int((currentLocation?.speed)!/1000*(60*60)) // m/s -> km /hr
            
            currentSpeedValue.text = ("\(String(currentSpeed)) k / hr")
            
            //            averageSpeedValue.text = ("\(Int(averageSpeed)) km / h")
            
            
            calculatedCalories()
        }
        
        myLocations.append(currentLocation!)
        
        
        showRoute()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: \(error.localizedDescription)")
    }
    
    // MARK: Calories
    
    func calculatedCalories() {
        
        weight = 50.0
        var CaloriesBurnedPerHourPerKg: Double
        
        switch averageSpeed {
        case 1.0..<20.0 : CaloriesBurnedPerHourPerKg = 4.0
        case 20.0..<30.0 : CaloriesBurnedPerHourPerKg = 8.4
        case 30.0..<210 : CaloriesBurnedPerHourPerKg = 12.6
        default : CaloriesBurnedPerHourPerKg = 0
        }
        
        caloriesBurned = Int(weight * CaloriesBurnedPerHourPerKg * (timeInterval/(100*60*60)))
        caloriesValue.text = "\(caloriesBurned) Kcal"
        
    }
    
    
    // MARK: Core Data
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func saveRecordsToCoreData() {
        
        let entityRecords = NSEntityDescription.insertNewObjectForEntityForName("Records", inManagedObjectContext: moc) as! Records
        
        entityRecords.timestamp = date
        entityRecords.distance = Int(traveledDistance)
        entityRecords.duration = timerString(timeInterval)
        entityRecords.calories = caloriesBurned
        
        var savedLocations = [Location]()
        for location in myLocations {
            
            let entityLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as! Location
            entityLocation.timeStamp = location.timestamp
            entityLocation.latitude = location.coordinate.latitude
            entityLocation.longitude = location.coordinate.longitude
            savedLocations.append(entityLocation)

        }
        
        entityRecords.location = NSSet(array: savedLocations)
        
        print ("entityRecords: \(entityRecords)")
        
        

        
        do {
            
            try self.moc.save()
            
            print ("save records to Core Data===========")
//            print("date:\(entityRecords.timestamp), distance: \(entityRecords.distance), duration: \(entityRecords.duration),calories: \(entityRecords.calories), savedLocations: \(savedLocations)")
            
        } catch {
            
            fatalError("Failure to save context: \(error)")
            
        }
    }
}

// Mark: Map

extension NewRecordViewController: MKMapViewDelegate {
    
    func showRoute() {
        
        if (myLocations.count > 1) {
            let sourceIndex = myLocations.count-1
            let destinationIndex = myLocations.count-2
            let oldCoord1 = myLocations[sourceIndex].coordinate
            let oldCoord2 = myLocations[destinationIndex].coordinate
            var coord = [oldCoord1, oldCoord2]
            let polyline = MKPolyline(coordinates: &coord, count: coord.count)
            
            if startIsOn == true {
                
                self.mapView!.addOverlay(polyline)
                
            } else {
                
                return
            }
        }
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

// MARK: Setup
extension NewRecordViewController {
    
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
        distanceValue.text = "0 m"
        letterSpacing(distanceValue.text!, letterSpacing: 0.7, label: distanceValue)
        
    }
    
    func setupAverageSpeed() {
        
        currentSpeedTitle.font = UIFont.mrTextStyle16Font()
        currentSpeedTitle.textColor = UIColor.mrWhiteColor()
        currentSpeedTitle.text = "Current Speed"
        letterSpacing(currentSpeedTitle.text!, letterSpacing: 0.3, label: currentSpeedTitle)
        
        
        currentSpeedValue.font = UIFont.mrTextStyle15Font()
        currentSpeedValue.textColor = UIColor.mrWhiteColor()
        currentSpeedValue.text = "0 km / h"
        letterSpacing(currentSpeedValue.text!, letterSpacing: 0.7, label: currentSpeedValue)
    }
    
    func setupCalories() {
        
        caloriesTitle.font = UIFont.mrTextStyle16Font()
        caloriesTitle.textColor = UIColor.mrWhiteColor()
        caloriesTitle.text = "Calories"
        letterSpacing(caloriesTitle.text!, letterSpacing: 0.3, label: caloriesTitle)
        
        
        caloriesValue.font = UIFont.mrTextStyle15Font()
        caloriesValue.textColor = UIColor.mrWhiteColor()
        caloriesValue.text = "0 kcal"
        letterSpacing(caloriesValue.text!, letterSpacing: 0.7, label: caloriesValue)
        
    }
    
    func setupTimeLabel() {
        timerLabel.font = UIFont(name: "RobotoMono-Light", size: 30)
        timerLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(timerLabel.text!, letterSpacing: 0.7, label: timerLabel)
        timerLabel.text = "00:00:00:00"
        
    }
    
    func setupMap(){
        mapView!.layer.cornerRadius = 10.0
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
    
    //MARK: Button animation
    
    func animateFromCircleToSquare(){
        
        UIView.animateWithDuration(
            0.5 , animations: {
                self.playPauseButtonView.transform = CGAffineTransformMakeScale(0.5, 0.5)},
            
            completion: { finish in
                UIView.animateWithDuration(0.6){
                    self.playPauseButtonView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    self.playPauseButtonView.layer.cornerRadius = 4
                }
        })
    }
    
    func animateFromSqareToCircle(){
        
        UIView.animateWithDuration(
            0.0 , animations: {
                self.playPauseButtonView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.playPauseButtonView.layer.cornerRadius = self.playPauseButtonView.frame.size.width / 2
        })
    }
    
    
}
