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
import Amplitude_iOS


protocol NewRecordViewControllerDelegate: class {
    
    func didDismiss()
    func setChart()
    func updateLabelValue()
}

class NewRecordViewController: UIViewController, CLLocationManagerDelegate, StatisticsViewControllerDelegate {
    
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
        
        if !timer.valid {

            trackTime()
            animateFromCircleToSquare()
            Amplitude.instance().logEvent("select_start_in_record_creating")
            
        } else {
            
            timer.invalidate()
            pauseTime()
            animateFromSqareToCircle()
            Amplitude.instance().logEvent("select_pause_in_record_creating")
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        Amplitude.instance().logEvent("select_cancel_in_record_creating")
        delegate?.didDismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        Amplitude.instance().logEvent("select_finish_in_record_creating")
        pauseTime()
        calculateAverageSpeed()
        saveRecordsToCoreData()
        passDataToStatisticsPage()
        timer.invalidate()
        delegate?.updateLabelValue()
    }
    
    weak var delegate: NewRecordViewControllerDelegate?
    
    //Timer
    var timeInterval = 0.0
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var elapsedTimePerRound = NSTimeInterval()
    var totalTimeInterval = NSTimeInterval()


    
    //Location
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var myLocations = [CLLocation]()
    var startLocation: CLLocation?
    var lastLocation: CLLocation?
    
    //Data properties
    var traveledDistance = 0.0
    var averageSpeed = 0.0
    var currentSpeed = 0.0
    var caloriesBurned = 0
    var date = NSDate()
    var weight = 0.0
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("__NewRecordsViewDidLoad")
        
        locationManager.delegate = self
        mapView!.delegate = self
        
        setup()
        drawCircle()
        setupPlayButton()
        getLocationUpdate()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = self.view.bounds
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
        
        print("__NewRecordsViewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("__NewRecordsViewWillDisappear")
        Amplitude.instance().logEvent("view_in_record_creating")
        locationManager.stopUpdatingLocation()
        
        mapView = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("__NewRecordsViewDidDisappear")
    }
    
    deinit {
        
        print("__Leave New Record Page")
        
    }
    
    func didDismiss2() {
        
        delegate?.didDismiss()
        delegate?.setChart()
    }
    
    // MARK: Timer
    func trackTime() {
    
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01,
            target: self,
            selector: #selector(addTime),
            userInfo: nil,
            repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    @objc func addTime(){
        
        timeInterval += 1
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = (currentTime - startTime)*100
        elapsedTime += 1.0
        elapsedTimePerRound = elapsedTime
        elapsedTime += totalTimeInterval

        timerLabel.text = "\(timerString(elapsedTime))"
    }
    
    func pauseTime() {
        totalTimeInterval += elapsedTimePerRound
    }
    
    func timerString(time: NSTimeInterval) -> String {
        
        let hours = Int(time) / (100 * 60 * 60)
        let minutes = Int(time) / (100 * 60) % 60
        let seconds = Int(time) / 100 % 60
        let secondsFrec = Int(time) % 100
        return String(format:"%02i:%02i:%02i.%02i", hours, minutes, seconds, secondsFrec)
    }
    
    // MARK: Location
    
    func getLocationUpdate() {
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.activityType = .Fitness
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            mapView!.showsUserLocation = true
            
        } else {
            
            //need add push notification
            print ("Need to Enable Location")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locationManager.location
        
        let center = CLLocationCoordinate2D(
            latitude: (currentLocation?.coordinate.latitude)!,
            longitude: (currentLocation?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpanMake(0.005, 0.005))
        
        mapView!.setRegion(region, animated: true)
        
        
        // Distance Calculation
        
        if startLocation == nil {
            startLocation = locations.last
        } else {
            startLocation = myLocations.last
        }
        let distance = startLocation?.distanceFromLocation(currentLocation!)
        if timer.valid {
            traveledDistance += distance ?? 0.0
            distanceValue.text = ("\(Int(traveledDistance)) m")
            
            calculateCurrentSpeed()
            calculatCalories()
            
            myLocations.append(currentLocation!)
        }
        showRoute()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Errors: \(error.localizedDescription)")
    }
    
    // MARK: Speed and Calories Calculation
    
    func calculateAverageSpeed() {
        
        averageSpeed = (traveledDistance / 1000) / (totalTimeInterval / (100 * 60 * 60))
    }
    
    func calculateCurrentSpeed() {
        
//        if let currentSpeed = currentLocation?.speed {
//            a = (currentSpeed<0) ? 0 : Int()
//            
//            if currentSpeed < 0 {
//                a = 0
//            } else {
//                a = Int()
//            }
//            
//            let a = optionalString ?? ""
//        }
        if let currentSpeed = currentLocation?.speed {
            
            let speed = (currentSpeed < 0) ? 0 : Int(currentSpeed/1000*(60*60))
            
            currentSpeedValue.text = ("\(String(speed)) km / hr")
        }
        
        
//        let currentSpeed = Int((currentLocation?.speed)!/1000*(60*60)) // m/s -> km /hr
//        currentSpeedValue.text = ("\(String(currentSpeed)) km / hr")
    }
    
    func calculatCalories() {
        
        weight = 50.0
        var CaloriesBurnedPerHourPerKg: Double
        
        switch averageSpeed {
        case 1.0 ..< 20.0: CaloriesBurnedPerHourPerKg = 4.0
        case 20.0 ..< 30.0: CaloriesBurnedPerHourPerKg = 8.4
        case 30.0 ..< 210: CaloriesBurnedPerHourPerKg = 12.6
        default : CaloriesBurnedPerHourPerKg = 0
        }
        
        caloriesBurned = Int(weight * CaloriesBurnedPerHourPerKg * (timeInterval/(100*60*60)))
        caloriesValue.text = "\(caloriesBurned) Kcal"
    }
    
    //MARK: Pass data
    
    func passDataToStatisticsPage() {
        
        let destinationController = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticsViewController")as! StatisticsViewController
        
        destinationController.delegate = self
        
        destinationController.timestamp = date
        destinationController.distance = traveledDistance
        destinationController.duration = totalTimeInterval
        destinationController.calories = Double(caloriesBurned)
        destinationController.averageSpeed = averageSpeed
        
        var passedLocations = [Locations]()
        for location in myLocations {
            guard
                let latitude: Double = location.coordinate.latitude,
                let longitude: Double = location.coordinate.longitude
                
                else {return}
            
            passedLocations.append(
                Locations(
                    latitude: latitude,
                    longitude: longitude))
        }
        
        destinationController.locations = passedLocations
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    // MARK: Core Data
    
    var moc: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    func saveRecordsToCoreData() {
        
        let entityRecords = NSEntityDescription.insertNewObjectForEntityForName("Records", inManagedObjectContext: moc!) as! Records
        
        entityRecords.timestamp = date
        entityRecords.distance = traveledDistance
        entityRecords.duration = totalTimeInterval
        entityRecords.calories = caloriesBurned
        entityRecords.averageSpeed = Int(averageSpeed)
        
        var savedLocations = [Location]()
        for location in myLocations {
            
            let entityLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc!) as! Location
            entityLocation.timeStamp = location.timestamp
            entityLocation.latitude = location.coordinate.latitude
            entityLocation.longitude = location.coordinate.longitude
            savedLocations.append(entityLocation)
        }
        
        entityRecords.location = NSOrderedSet(array: savedLocations)
        
        do {
            try self.moc?.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //MARK: Test date
    func dateTest(dateString: String){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        date = dateFormatter.dateFromString(dateString)!
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
            
            if timer.valid {
                
                self.mapView!.addOverlay(polyline)
                
            } else { return }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.mrBubblegumColor()
            polylineRenderer.lineWidth = 10
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
}


// MARK: Setup
extension NewRecordViewController {
    
    func setup() {
        
        // setupBackground
        view.backgroundColor = UIColor.clearColor()
        let color1 = UIColor.clearColor().colorWithAlphaComponent(0.6)
        let color2 = UIColor.clearColor().colorWithAlphaComponent(0.4)
        gradient.frame = self.view.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        //setupDistance
        distanceTitle.font = UIFont.mrTextStyle16Font()
        distanceTitle.textColor = UIColor.mrWhiteColor()
        distanceTitle.text = "Distance"
        letterSpacing(distanceTitle.text!, letterSpacing: 0.3, label: distanceTitle)
        
        distanceValue.font = UIFont.mrTextStyle15Font()
        distanceValue.textColor = UIColor.mrWhiteColor()
        distanceValue.text = "0 m"
        letterSpacing(distanceValue.text!, letterSpacing: 0.7, label: distanceValue)
        
        //setupAverageSpeed
        
        currentSpeedTitle.font = UIFont.mrTextStyle16Font()
        currentSpeedTitle.textColor = UIColor.mrWhiteColor()
        currentSpeedTitle.text = "Current Speed"
        letterSpacing(currentSpeedTitle.text!, letterSpacing: 0.3, label: currentSpeedTitle)
        
        currentSpeedValue.font = UIFont.mrTextStyle15Font()
        currentSpeedValue.textColor = UIColor.mrWhiteColor()
        currentSpeedValue.text = "0 km / h"
        letterSpacing(currentSpeedValue.text!, letterSpacing: 0.7, label: currentSpeedValue)
        
        
        //setupCalories
        caloriesTitle.font = UIFont.mrTextStyle16Font()
        caloriesTitle.textColor = UIColor.mrWhiteColor()
        caloriesTitle.text = "Calories"
        letterSpacing(caloriesTitle.text!, letterSpacing: 0.3, label: caloriesTitle)
        
        caloriesValue.font = UIFont.mrTextStyle15Font()
        caloriesValue.textColor = UIColor.mrWhiteColor()
        caloriesValue.text = "0 kcal"
        letterSpacing(caloriesValue.text!, letterSpacing: 0.7, label: caloriesValue)
        
        //setupTimeLabel
        
        timerLabel.font = UIFont(name: "RobotoMono-Light", size: 30)
        timerLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(timerLabel.text!, letterSpacing: 0.7, label: timerLabel)
        timerLabel.text = "00:00:00:00"
        
        //setupMap
        mapView!.layer.cornerRadius = 10.0
        
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        
        let attributedText = NSMutableAttributedString (string: text)
        
        attributedText.addAttribute(
            NSKernAttributeName,
            value: letterSpacing,
            range: NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        
    }
    
    func drawCircle() {
        
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            roundedRect: circleView.bounds,
            byRoundingCorners: [ .AllCorners],
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
            0.5 , animations: {
                self.playPauseButtonView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.playPauseButtonView.layer.cornerRadius = self.playPauseButtonView.frame.size.width / 2
        })
    }
}
