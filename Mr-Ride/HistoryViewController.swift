//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/29/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import CoreData




class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        print ("HistoryPage : SideBarButtonTapped")
    }
    
    let recordModel = DataManager.sharedDataManager
    
    
//    var saveRecords = [SavedRecords]()
//    
//    var locationList = [Locations]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HistoryViewDidLoad")
        
        setup()
        
        let nib = UINib(nibName: "HistoryTableViewCell" , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.dataSource = self  // 或這是從storyboard拉tableview到controller選擇dataSource
        tableView.delegate = self   // 或這是從storyboard拉tableview到controller選擇delegate
        
        recordModel.fetchRecordsCoreData()
        
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recordModel.saveRecords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.dateLabel.text = "\(dateString(recordModel.saveRecords[indexPath.row].timestamp))"
        cell.distanceLabel.text = "\(numberString((recordModel.saveRecords[indexPath.row].distance)/1000)) km"
        cell.durationLabel.text = "\(timerString(recordModel.saveRecords[indexPath.row].duration))"
        
        return cell
    }
    
    
    //MARK: Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print ("row\(indexPath.row)selected")
       
        let destinationController = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticsViewController")as! StatisticsViewController
        destinationController.records = recordModel.saveRecords[indexPath.row]
        destinationController.isFromHistory = true
        self.navigationController?.pushViewController(destinationController, animated: true)

    }
    
    
   
    func dateString(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
        
    }
    
    func numberString(number: Double ) -> NSString {
        
        return NSString(format:"%.2f",number)
    }
    
    func timerString(time: Double) -> String {
        
        let hours = Int(time) / (100*60*60)
        let minutes = Int(time) / (100 * 60) % 60
        let seconds = Int(time) / 100 % 60
        let secondsFrec = Int(time) % 100
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds, secondsFrec)
    }
    
    
    //MARK: setup
    
    func setup() {
        
        view.backgroundColor = UIColor.mrLightblueColor()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.redColor()
        
        let gradient = CAGradientLayer()
        let color1 = UIColor.mrLightblueColor().colorWithAlphaComponent(1)
        let color2 = UIColor.mrPineGreen50Color().colorWithAlphaComponent(0.5)
        gradient.frame = backgroundImage.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        backgroundImage.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    
    
}
