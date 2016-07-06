//
//  HistoryTableViewCell.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/8/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var thLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()

    }
    
    func setup(){
        
        self.backgroundColor = UIColor.clearColor()
        cellView.backgroundColor = UIColor.mrPineGreen85Color()
        
        distanceLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        distanceLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(distanceLabel.text!, letterSpacing: -0.6, label: distanceLabel)
        
        durationLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        durationLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(durationLabel.text!, letterSpacing: -0.6, label: durationLabel)
        
        dateLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        dateLabel.textColor = UIColor.mrWhiteColor()
        letterSpacing(dateLabel.text!, letterSpacing: -0.6, label: dateLabel)
        
        thLabel.font = UIFont(name: "RobotoMono-Light", size: 12)
        thLabel.textColor = UIColor.mrWhiteColor()
        thLabel.text = "th"
        letterSpacing(thLabel.text!, letterSpacing: -0.6, label: thLabel)
        
    }
        
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }

    
}
