//
//  HistoryFooterTableViewCell.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/16/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var footerCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor() 
        footerCell.backgroundColor = UIColor.clearColor()

    }
}
