//
//  StatisticsView.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/31/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import MapKit


class StatisticsView: UIView {
    
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareOnFBButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var distanceTitle: UILabel!
    
    @IBOutlet weak var distanceValue: UILabel!
    
    @IBOutlet weak var averageSpeedTitle: UILabel!
    
    @IBOutlet weak var averageSpeedValue: UILabel!
    
    @IBOutlet weak var caloriesTitle: UILabel!
    
    @IBOutlet weak var caloriesValue: UILabel!
    
    @IBOutlet weak var totalTimeTitle: UILabel!
    
    @IBOutlet weak var totalTimeValue: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var medal: UIImageView!
    
    @IBOutlet weak var goodJob: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var highlignt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("____StatisticsViewAwakeFromNib")
        
        setupBackground()
        setupDistance()
        setupAverageSpeed()
        setupCalories()
        setupTimeLabel()
        setupMap()
        setupMedal()
        setupGoodJob()
        setupShareButton()
    }
    
    func setupBackground() {
        
        self.opaque = true
        backgroundColor = UIColor.clearColor()
        
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        gradient.frame = self.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        layer.insertSublayer(gradient, atIndex: 0)
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
        
        averageSpeedTitle.font = UIFont.mrTextStyle16Font()
        averageSpeedTitle.textColor = UIColor.mrWhiteColor()
        averageSpeedValue.text = "AverageSpeed"
        letterSpacing(averageSpeedTitle.text!, letterSpacing: 0.3, label: averageSpeedTitle)
        
        
        averageSpeedValue.font = UIFont.mrTextStyle15Font()
        averageSpeedValue.textColor = UIColor.mrWhiteColor()
        averageSpeedValue.text = "0 km / h"
        letterSpacing(averageSpeedValue.text!, letterSpacing: 0.7, label: averageSpeedValue)
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
        
        totalTimeTitle.font = UIFont.mrTextStyle16Font()
        totalTimeTitle.textColor = UIColor.mrWhiteColor()
        totalTimeTitle.text = "Total Time"
        letterSpacing(caloriesTitle.text!, letterSpacing: 0.3, label: caloriesTitle)
        
        totalTimeValue.font = UIFont(name: "RobotoMono-Light", size: 30)
        totalTimeValue.textColor = UIColor.mrWhiteColor()
        letterSpacing(totalTimeValue.text!, letterSpacing: 0.7, label: totalTimeValue)
        totalTimeValue.text = "00:00:00:00"
        
    }
    
    func setupMap() {
        
        mapView.layer.cornerRadius = 10.0
        mapHeightConstraint.constant = mapHeightConstraintConstant()!
    }
    
    func setupMedal() {
        
        medal.image = UIImage(named: "image-medal")
        
    }
    
    
    func setupGoodJob() {
        
        goodJob.font = UIFont.mrTextStyle12Font()
        goodJob.textColor = UIColor.mrWhiteColor()
        goodJob.text = "Good Job!"
        letterSpacing(goodJob.text!, letterSpacing: 0.3, label: goodJob)
    }
    
    
    func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    func shareOnFBTopConstraintConstant() -> CGFloat? {
        switch(screenHeight()){
        case 480: return 5
        case 568: return 20
        default: return 38
        }
    }
    
    func mapHeightConstraintConstant() -> CGFloat? {
        switch(screenHeight()){
        case 480: return 0
        case 568: return 140
        default: return 200
        }
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    
    func setupShareButton() {
        shareButton.layer.backgroundColor = UIColor.denimBlueColor().CGColor
        shareButton.layer.cornerRadius = 10
        shareButton.layer.masksToBounds = true
        shareButton.setTitle("  Share on Facebook  ", forState: UIControlState.Normal)
        shareButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        shareButton.titleLabel?.font = UIFont.mrTextStyle4Font(size: 20)
        
        highlignt.backgroundColor = UIColor.highlightColor()
        
        let hightlightlLayer = CAShapeLayer()
        let roundedPath = UIBezierPath(
            roundedRect: shareButton.bounds,
            byRoundingCorners:[.TopLeft, .TopRight],
            cornerRadii: CGSize(width: 10 , height:10))
        
        hightlightlLayer.path = roundedPath.CGPath
        highlignt.layer.mask = hightlightlLayer
        highlignt.text = ""
        highlignt.userInteractionEnabled = false
        
        shareOnFBButtonTopConstraint.constant = shareOnFBTopConstraintConstant()!
        
    }
    
}
