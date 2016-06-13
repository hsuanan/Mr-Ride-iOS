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
        
        // remove problem of unable to simultaneously satisfy constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = UIColor.mrDarkSlateBlueColor()
        
        itemLabel.textColor = UIColor.mrWhite50Color()
        itemLabel.font = UIFont.mrTextStyle7Font()
        itemLabel.layer.shadowColor = UIColor.blackColor().CGColor
        itemLabel.layer.shadowOpacity = 0.25
        itemLabel.layer.shadowRadius = 2
        itemLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            itemLabel.highlightedTextColor = UIColor.mrWhiteColor()
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mrDarkSlateBlueColor()
            self.selectedBackgroundView = bgColorView
            
            bullet.frame = CGRectMake (30, 28, 8, 8)
            bullet.layer.cornerRadius = bullet.frame.size.width / 2
            bullet.backgroundColor = UIColor.whiteColor()

        }
        else {
            
            bullet.backgroundColor = UIColor.clearColor()

        }
        

    }
    
    func drawBullet(){
        bullet.layer.cornerRadius = bullet.frame.size.width / 2
        bullet.backgroundColor = UIColor.clearColor()
    }

}
