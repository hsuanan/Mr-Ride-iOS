//
//  HomePageViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/25/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {


    @IBOutlet weak var totalDistanceTitle: UILabel!
  
    @IBOutlet weak var totalDistanceValue: UILabel!
    
    @IBOutlet weak var totalCountTitle: UILabel!
  
    @IBOutlet weak var totalCoutValue: UILabel!
    
    @IBOutlet weak var averageSpeedTitle: UILabel!
    
    @IBOutlet weak var averageSpeedValue: UILabel!
    
    @IBOutlet weak var letsRideButton: UIButton!
    
    @IBOutlet weak var letsRideButtonLabel: UILabel!
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()

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
}
