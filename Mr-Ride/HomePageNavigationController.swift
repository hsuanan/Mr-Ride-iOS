//
//  HomePageNavigationController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/26/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HomePageNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //setup status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent

    }
    
    func setupNavigationBar(){
        
        navigationBar.barTintColor = UIColor.mrLightblueColor()
        
        //remove navigationbar border/shadow
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //setup Logo
        let originImage = UIImage(named: "icon-bike")
        let tintedImage = originImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.topItem?.titleView = UIImageView(image: tintedImage)
        
        //setup sideBar
        let originSidBarImage = UIImage(named: "icon-menu")
        let tintedSideBarImage = originSidBarImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.topItem?.leftBarButtonItem?.customView = UIImageView(image: tintedSideBarImage)
        
    }
    
   
}
