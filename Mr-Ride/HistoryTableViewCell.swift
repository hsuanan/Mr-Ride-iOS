//
//  HistoryTableViewCell.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/8/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var thLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(){
        
        self.backgroundColor = UIColor.mrPineGreen85Color()        
        
        distanceLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        distanceLabel.textColor = UIColor.mrWhiteColor()
        
        durationLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        durationLabel.textColor = UIColor.mrWhiteColor()
        
        dateLabel.font = UIFont(name: "RobotoMono-Light", size: 24)
        dateLabel.textColor = UIColor.mrWhiteColor()
        
        thLabel.font = UIFont(name: "RobotoMono-Light", size: 12)
        thLabel.textColor = UIColor.mrWhiteColor()
        thLabel.text = "th"
        
    }
        
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }

    
}
