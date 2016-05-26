//
//  NewRecordNavigationController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/23/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class NewRecordNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        setupRideDetailsNavigationBar()
        
    }
    
    
    func setupRideDetailsNavigationBar(){
        
        //change status bar color to white
        navigationBar.barStyle = UIBarStyle.Black
        
        navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //setup Date
        let todayDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.stringFromDate(todayDate)
        
        navigationBar.topItem?.title = "\(dateString)"
        
        //Cancel BarButton
        navigationBar.topItem?.leftBarButtonItem?.title = "Cancel"
        navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        navigationBar.translucent = false

    }
    

}
