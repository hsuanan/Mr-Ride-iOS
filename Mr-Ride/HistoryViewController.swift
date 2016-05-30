//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/29/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        print ("HistoryPage : SideBarButtonTapped")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
