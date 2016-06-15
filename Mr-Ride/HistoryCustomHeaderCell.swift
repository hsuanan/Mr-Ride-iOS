//
//  HistoryCustomHeaderCell.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/14/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryCustomHeaderCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.whiteColor()
        
//        dateLabel.font = UIFont.mrTextStyle125Font()
        dateLabel.textColor = UIColor.mrDarkSlateBlueColor()
        letterSpacing(dateLabel.text!, letterSpacing: -0.3, label: dateLabel)
        
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }

    
    
}