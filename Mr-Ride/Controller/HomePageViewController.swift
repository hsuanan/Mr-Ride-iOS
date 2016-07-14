//
//  HomePageViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/25/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import Charts
import Crashlytics
import Amplitude_iOS


class HomePageViewController: UIViewController, NewRecordViewControllerDelegate {
    
    @IBOutlet weak var totalDistanceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var letsRideButttonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var totalDistanceTitleLabel: UILabel!
    
    @IBOutlet weak var totalDistanceValueLabel: UILabel!
    
    @IBOutlet weak var totalCountTitleLabel: UILabel!
    
    @IBOutlet weak var totalCountValueLabel: UILabel!
    
    @IBOutlet weak var averageSpeedTitleLabel: UILabel!
    
    @IBOutlet weak var averageSpeedValueLabel: UILabel!
    
    @IBOutlet weak var letsRideButton: UIButton!
    
    @IBOutlet weak var letsRideButtonLabel: UILabel!
    
    @IBAction func letsRideButtonTapped(sender: AnyObject) {
        
        TrackingManager.sharedManager.createEventTracking("Home", action: "select_ride_in_home")
        
        let newRecordNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("NewRecordNavigationController") as! UINavigationController
        newRecordNavigationController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.navigationController?.presentViewController(newRecordNavigationController, animated: true, completion: nil)
        
        let newRecordViewController = newRecordNavigationController.viewControllers.first as! NewRecordViewController
        newRecordViewController.delegate = self
        
        hideLabel()
    }
    
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        TrackingManager.sharedManager.createEventTracking("Home", action: "select_menu_in_home")
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    var totalCount: Int?
    var averageSpeed = 0.0
    
    let recordModel = DataManager.sharedDataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("HomePageViewDidLoad")
        
        recordModel.fetchRecordsCoreData()
        setupLabel()
        setLabelValue()
        setChart()
        
        //        crashlyticsTest()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HomePageViewDidAppear")

        TrackingManager.sharedManager.createScreenTracking("view_in_home")
    }
    
    func setLabelValue() {
        
        totalCount = recordModel.saveRecords.count ?? 0
        totalCountValueLabel.text = "\(totalCount!)"
        
        var totalDistance = 0.0
        var duration = 0.0
        
        for data in recordModel.saveRecords {
            totalDistance += data.distance
            duration += data.duration
        }
        
        let stringTotalDistance = NSString(format: "%.1f", totalDistance/1000)
        totalDistanceValueLabel.text = "\(stringTotalDistance) km"
        
        
        if totalDistance == 0.0 && duration == 0.0 {
            averageSpeed = 0.0
        } else {
            averageSpeed = totalDistance/1000/(duration/(100*60*60))
        }
        let stringAverageSpeed = NSString(format: "%.1f", averageSpeed)
        averageSpeedValueLabel.text = "\(stringAverageSpeed) km / h"
    }
    
    func hideLabel() {
        
        totalDistanceTitleLabel.hidden = true
        totalDistanceValueLabel.hidden = true
        totalCountTitleLabel.hidden = true
        totalCountValueLabel.hidden = true
        averageSpeedTitleLabel.hidden = true
        averageSpeedValueLabel.hidden = true
        letsRideButton.hidden = true
        letsRideButtonLabel.hidden = true
    }
    

    
    func showLabel() {
        
        totalDistanceTitleLabel.hidden = false
        totalDistanceValueLabel.hidden = false
        totalCountTitleLabel.hidden = false
        totalCountValueLabel.hidden = false
        averageSpeedTitleLabel.hidden = false
        averageSpeedValueLabel.hidden = false
        letsRideButton.hidden = false
        letsRideButtonLabel.hidden = false
    }
    
    //MARK: Chart
    func setChart() {
        
        var dates=[String]()
        var distances=[Double]()
        
        lineChartView.backgroundColor = UIColor.mrLightblueColor()
        lineChartView.noDataText = ""
        
        for data in recordModel.saveRecords {
            
            let date = data.timestamp
            let distance = data.distance as Double
            
            dates.append(dateString2(date))
            distances.append(distance)
        }
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(value: distances.reverse()[i], xIndex: i)
            dataEntries.append(dataEntry)
            
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
            let lineChartData = LineChartData(xVals: dates.reverse(), dataSet: lineChartDataSet)
            lineChartView.data = lineChartData
            
            lineChartView.descriptionText = ""
            lineChartView.backgroundColor = UIColor.mrLightblueColor()
            
            
            lineChartView.rightAxis.enabled = false
            lineChartView.leftAxis.enabled = false
            
            lineChartView.xAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.drawAxisLineEnabled = false
            lineChartView.xAxis.drawLabelsEnabled = false
            
            lineChartView.legend.enabled = false
            lineChartView.userInteractionEnabled = false
            
            lineChartDataSet.colors = [UIColor.clearColor()]
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawValuesEnabled = false
            
            lineChartDataSet.mode = .CubicBezier
            lineChartDataSet.drawFilledEnabled = true
            let gradColors = [UIColor.mrRobinsEggBlue0Color().CGColor,UIColor.mrWaterBlueColor().CGColor]
            let colorLocations:[CGFloat] = [0.0, 0.5]
            if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocations) {
                lineChartDataSet.fill = ChartFill(linearGradient: gradient, angle: 90.0)
            }
        }
    }
    
    //MARK: Setup
    
    func setupLabel(){
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        totalDistanceTitleLabel.font = UIFont.mrTextStyle16Font()
        totalDistanceTitleLabel.textColor = UIColor.mrWhiteColor()
        totalDistanceTitleLabel.text = "Total Distance"
        letterSpacing(totalDistanceTitleLabel.text!, letterSpacing: 0.3, label: totalDistanceTitleLabel)
        
        totalDistanceValueLabel.font = UIFont.mrTextStyle14Font()
        totalDistanceValueLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(totalDistanceValueLabel.text!, letterSpacing: 1.9, label: totalDistanceValueLabel)
        //letter shadow
        totalDistanceValueLabel.layer.shadowColor = UIColor.blackColor().CGColor
        totalDistanceValueLabel.layer.shadowOpacity = 0.25
        totalDistanceValueLabel.layer.shadowRadius = 2
        totalDistanceValueLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
        totalCountTitleLabel.font = UIFont.mrTextStyle16Font()
        totalCountTitleLabel.textColor = UIColor.mrWhiteColor()
        totalCountTitleLabel.text = "Total Count"
        letterSpacing(totalCountTitleLabel.text!, letterSpacing: 0.3, label: totalCountTitleLabel)
        
        totalCountValueLabel.font = UIFont.mrTextStyle15Font()
        totalCountValueLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(totalCountValueLabel.text!, letterSpacing: 0.7, label: totalCountValueLabel)
        
        averageSpeedTitleLabel.font = UIFont.mrTextStyle16Font()
        averageSpeedTitleLabel.textColor = UIColor.mrWhiteColor()
        averageSpeedTitleLabel.text = "Average Speed"
        letterSpacing(averageSpeedTitleLabel.text!, letterSpacing: 0.3, label: averageSpeedTitleLabel)
        
        averageSpeedValueLabel.font = UIFont.mrTextStyle15Font()
        averageSpeedValueLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(averageSpeedValueLabel.text!, letterSpacing: 0.7, label: averageSpeedValueLabel)
        
        setupLetsRideButton(letsRideButton)
        
        letsRideButtonLabel.font = UIFont.mrTextStyle11Font()
        letsRideButtonLabel.textColor = UIColor.mrLightblueColor()
        letsRideButtonLabel.text = "Let's Ride"
        letterSpacing(letsRideButtonLabel.text!, letterSpacing: 0.7, label: letsRideButtonLabel)
        
        letsRideButtonLabel.layer.shadowColor = UIColor.blackColor().CGColor
        letsRideButtonLabel.layer.shadowOpacity = 0.25
        letsRideButtonLabel.layer.shadowRadius = 2
        letsRideButtonLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        
        totalDistanceConstraint.constant = totalDistanceConstraintConstant()
        letsRideButttonTopConstraint.constant = letsRideButtonConstraintConstant()
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    
    func setupLetsRideButton(Button: UIButton) {
        
        letsRideButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        letsRideButton.layer.cornerRadius = 30
        letsRideButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        letsRideButton.layer.shadowOpacity = 0.25
        letsRideButton.layer.shadowRadius = 2
        
    }
    
    func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    func totalDistanceConstraintConstant() -> CGFloat {
        switch(screenHeight()){
        case 480: return 5
        case 568: return 35
        default: return 75
        }
    }
    
    func letsRideButtonConstraintConstant() -> CGFloat {
        switch(screenHeight()){
        case 480: return 15
        default: return 51
        }
    }
    
    
    func dateString2(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.stringFromDate(date)
        
    }
    
    func testFontInstall(){
        
        for fontFamilyName in UIFont.familyNames() {
            print("-- \(fontFamilyName) --")
            
            for fontName in UIFont.fontNamesForFamilyName(fontFamilyName as String) {
                print(fontName)
            }
        }
    }
    
    //MARK: CrashlyticsTest
    func crashlyticsTest() {
        let button = UIButton(type: UIButtonType.RoundedRect)
        button.frame = CGRectMake(30, 100, 100, 30)
        button.setTitle("Crash", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(sender: AnyObject){
        Crashlytics.sharedInstance().crash()
    }
}

