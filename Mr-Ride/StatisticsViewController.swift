//
//  StatisticsViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/23/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class StatisticsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let statisticsView = StatisticsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidLayoutSubviews() {
        
        statisticsView.gradient.frame = self.view.bounds
    }

}
