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

        setupNewRecordNavigationBar()
        
    }
    
    
    func setupNewRecordNavigationBar(){
        
        
        navigationBar.translucent = false
        
        //change status bar color to white
        navigationBar.barStyle = UIBarStyle.Black
        
        //setup Date
        let todayDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.stringFromDate(todayDate)
        
        navigationBar.topItem?.title = "\(dateString)"
        navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationBar.topItem?.leftBarButtonItem?.title = "Cancel"
        navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        navigationBar.topItem?.rightBarButtonItem?.title = "Finish"
        navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    

}
