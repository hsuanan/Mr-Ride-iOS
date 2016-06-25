//
//  HomePageViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/25/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import Charts


class HomePageViewController: UIViewController, NewRecordViewControllerDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var totalDistanceTitle: UILabel!
    
    @IBOutlet weak var totalDistanceValue: UILabel!
    
    @IBOutlet weak var totalCountTitle: UILabel!
    
    @IBOutlet weak var totalCoutValue: UILabel!
    
    @IBOutlet weak var averageSpeedTitle: UILabel!
    
    @IBOutlet weak var averageSpeedValue: UILabel!
    
    @IBOutlet weak var letsRideButton: UIButton!
    
    @IBAction func letsRideButtonTapped(sender: AnyObject) {
        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: #selector(newNewViewControllerDidDismiss(_:)),
//            name: "NewRecordViewControllerWillDismiss",
//            object: nil
//        )
        
        let nvc = self.storyboard!.instantiateViewControllerWithIdentifier("NewRecordNavigationController") as! UINavigationController
        nvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
        let newRecordVC = nvc.viewControllers.first as! NewRecordViewController

  
        
        newRecordVC.delegate = self
       
        
        hideLabel()

    }
    
    func didDismiss() {
        
        totalDistanceTitle.hidden = false
        totalDistanceValue.hidden = false
        totalCountTitle.hidden = false
        totalCoutValue.hidden = false
        averageSpeedTitle.hidden = false
        averageSpeedValue.hidden = false
        letsRideButton.hidden = false
        letsRideButtonLabel.hidden = false
        
        print("labelResume")
    }
    
//    @objc func newNewViewControllerDidDismiss(notification: NSNotification) {
//        
//        
//        print("did received notification")
//        
//    }
    
    @IBOutlet weak var letsRideButtonLabel: UILabel!
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        print ("HomePage : SideBarButtonTapped")
        
    }
    
//    @IBAction func cancelToHomePageViewController(segue:UIStoryboardSegue) {
//    } //cancel button
    
    let recordModel = DataManager.sharedDataManager
    
//    weak var delegate: cancelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        print ("HomePageViewDidLoad")
        
        setupLabel()
        //        historyPageController.getDataForChart()
        
        //
        //        dates = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        //        distances = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        recordModel.fetchRecordsCoreData()

        setChart()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HomePageViewDidAppear")
        
        didDismiss()
    
    }
    
    
    //MARK: Chart
    
    func setChart() {
        
        var dates=[String]()
        var distances=[Double]()
        
        lineChartView.backgroundColor = UIColor.mrLightblueColor()
        lineChartView.noDataText = ""
        
        for data in recordModel.saveRecords {
            
            let date = data.timestamp,
            distance = data.distance as Double
            
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
            
            
            
            //        lineChartDataSet.setColor(UIColor.mrBrightSkyColor())
            lineChartDataSet.colors = [UIColor.clearColor()]
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawValuesEnabled = false
            
            lineChartDataSet.mode = .CubicBezier
            lineChartDataSet.drawFilledEnabled = true
            let gradColors = [UIColor.mrRobinsEggBlue0Color().CGColor,UIColor.mrWaterBlueColor().CGColor]
            let colorLocations:[CGFloat] = [0.0, 1.0]
            if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocations) {
                lineChartDataSet.fill = ChartFill(linearGradient: gradient, angle: 90.0)
                
            }
        }
    }
    
    // MARK : Setup Label
    
    func setupLabel(){
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        totalDistanceTitle.font = UIFont.mrTextStyle16Font()
        totalDistanceTitle.textColor = UIColor.mrWhiteColor()
        totalDistanceTitle.text = "Total Distance"
        letterSpacing(totalDistanceTitle.text!, letterSpacing: 0.3, label: totalDistanceTitle)
        
        totalDistanceValue.font = UIFont.mrTextStyle14Font()
        totalDistanceValue.textColor = UIColor.mrWhiteColor()
        totalDistanceValue.text = "12.5 km"
        letterSpacing(totalDistanceValue.text!, letterSpacing: 1.9, label: totalDistanceValue)
        //letter shadow
        totalDistanceValue.layer.shadowColor = UIColor.blackColor().CGColor
        totalDistanceValue.layer.shadowOpacity = 0.25
        totalDistanceValue.layer.shadowRadius = 2
        totalDistanceValue.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
        totalCountTitle.font = UIFont.mrTextStyle16Font()
        totalCountTitle.textColor = UIColor.mrWhiteColor()
        totalCountTitle.text = "Total Count"
        letterSpacing(totalCountTitle.text!, letterSpacing: 0.3, label: totalCountTitle)
        
        totalCoutValue.font = UIFont.mrTextStyle15Font()
        totalCoutValue.textColor = UIColor.mrWhiteColor()
        totalCoutValue.text = "14 times"
        letterSpacing(totalCoutValue.text!, letterSpacing: 0.7, label: totalCoutValue)
        
        averageSpeedTitle.font = UIFont.mrTextStyle16Font()
        averageSpeedTitle.textColor = UIColor.mrWhiteColor()
        averageSpeedTitle.text = "Average Speed"
        letterSpacing(averageSpeedTitle.text!, letterSpacing: 0.3, label: averageSpeedTitle)
        
        averageSpeedValue.font = UIFont.mrTextStyle15Font()
        averageSpeedValue.textColor = UIColor.mrWhiteColor()
        averageSpeedValue.text = "8 km / h"
        letterSpacing(averageSpeedValue.text!, letterSpacing: 0.7, label: averageSpeedValue)
        
        setupLetsRideButton(letsRideButton)
        
        letsRideButtonLabel.font = UIFont.mrTextStyle11Font()
        letsRideButtonLabel.textColor = UIColor.mrLightblueColor()
        letsRideButtonLabel.text = "Let's Ride"
        letterSpacing(letsRideButtonLabel.text!, letterSpacing: 0.7, label: letsRideButtonLabel)
        letsRideButtonLabel.layer.shadowColor = UIColor.blackColor().CGColor
        letsRideButtonLabel.layer.shadowOpacity = 0.25
        letsRideButtonLabel.layer.shadowRadius = 2
        letsRideButtonLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    
    func setupLetsRideButton(Button: UIButton) {
        
        letsRideButton.layer.backgroundColor = UIColor.clearColor().CGColor
        
        let roundLayer = CAShapeLayer()
        let shadowLayer = CAShapeLayer()
        
        //round corner
        let roundedPath = UIBezierPath(
            roundedRect: letsRideButton.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight, .TopLeft, .TopRight],
            cornerRadii: CGSize(width: 60, height: 60))
        
        roundLayer.frame = letsRideButton.bounds
        roundLayer.path = roundedPath.CGPath
        roundLayer.fillColor = UIColor.whiteColor().CGColor
        letsRideButton.layer.insertSublayer(roundLayer, atIndex: 0)
        
        //shadow
        shadowLayer.frame = letsRideButton.bounds
        shadowLayer.fillColor = UIColor.clearColor().CGColor
        shadowLayer.shadowPath = roundedPath.CGPath
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowOpacity = 0.25
        shadowLayer.shadowRadius = 2
        letsRideButton.layer.insertSublayer(shadowLayer, below: roundLayer)
        
    }
    
    func hideLabel() {
        
        totalDistanceTitle.hidden = true
        totalDistanceValue.hidden = true
        totalCountTitle.hidden = true
        totalCoutValue.hidden = true
        averageSpeedTitle.hidden = true
        averageSpeedValue.hidden = true
        letsRideButton.hidden = true
        letsRideButtonLabel.hidden = true

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
            
            print(" ")
        }
        
    }
    
}

