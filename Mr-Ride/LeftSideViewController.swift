//
//  LeftSideViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/28/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray : [String] = [ "Home", "History", "Map" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print ("SideViewDidLoad")
        
        view.backgroundColor = UIColor.mrDarkSlateBlueColor()
        tableView.backgroundColor = UIColor.mrDarkSlateBlueColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuCell", forIndexPath: indexPath) as! LeftSideTableViewCell
        
        cell.itemLabel.text = itemArray[indexPath.row]
        cell.selectionStyle = .None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.row)
            
        {
            
        case 0:
            
            let centerNav = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController") as! HomePageNavigationController
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = centerNav
            
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
        case 1:
            
            let historyNav = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryNavigationController") as! HistoryNavigationController
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = historyNav
            
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
        case 2:
            
            let mapNav = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewNavigationController") as! MapViewNavigationController
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = mapNav
            
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
            
        default:
            
            print("\(itemArray[indexPath.row]) is selected")
            
        }
    }
        
    
    
    
    //        estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
    //        {
    //            return UITableViewAutomaticDimension;
    //        }
    //
    //    }
    

    
}
