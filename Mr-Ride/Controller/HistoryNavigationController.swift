//
//  HistoryNavigationController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/29/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barStyle = UIBarStyle.Black
        navigationBar.topItem?.title = "Hsitory"
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationBar.translucent = false
        
    }
}
