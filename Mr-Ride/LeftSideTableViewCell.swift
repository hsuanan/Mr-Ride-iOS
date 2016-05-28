//
//  LeftSideTableViewCell.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/28/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class LeftSideTableViewCell: UITableViewCell {


    @IBOutlet weak var bullet: UIView!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    
    
    override func awakeFromNib() {

        
        super.awakeFromNib()
        
        backgroundColor = UIColor.mrDarkSlateBlueColor()
//        itemLabel.textColor = UIColor.mrWhiteColor()
//        itemLabel.font = UIFont.mrTextStyle3Font()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawBullet(){
        
//        bullet.layer.cornerRadius = bounds.size.width / 2
    }
}
