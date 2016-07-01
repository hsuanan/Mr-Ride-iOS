//
//  MapViewNavigationController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/20/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class MapViewNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = UIBarStyle.Black
        navigationBar.topItem?.title = "Map"
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationBar.translucent = false
    }

}
