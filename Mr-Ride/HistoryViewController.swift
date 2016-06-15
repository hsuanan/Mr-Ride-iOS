//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/29/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import CoreData



class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HistoryViewDidLoad")
        
        setup()
        
        let nib = UINib(nibName: "HistoryTableViewCell" , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
        let nibHealder = UINib(nibName: "HistoryCustomHeaderCell", bundle: nil)
        tableView.registerNib(nibHealder, forCellReuseIdentifier: "HistoryCustomHeaderCell")
        
        tableView.dataSource = self  // or 從storyboard拉tableview到controller選擇dataSource
        tableView.delegate = self   // or 從storyboard拉tableview到controller選擇delegate
        
        recordModel.fetchRecordsCoreData()
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return recordModel.fetchedResultsController.sections?.count ?? 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        if let sections = recordModel.fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].numberOfObjects
        } else { return 0 }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        let records = recordModel.fetchedResultsController.objectAtIndexPath(indexPath) as! Records
        
        guard
            let timestemp = records.timestamp,
            let distance = records.distance as? Double,
            let duration = records.duration as? Double
            
            else {
                print("[StaticsViewController](fetchRecordsCoreData) can't get Records")
                return cell}
        
        
        cell.dateLabel.text = "\(dateString(timestemp))"
        cell.distanceLabel.text = "\(numberString(distance/1000)) km"
        cell.durationLabel.text = "\(timerString(duration))"
        
        
        
        //        cell.dateLabel.text = "\(dateString(recordModel.saveRecords[indexPath.row].timestamp))"
        //        cell.distanceLabel.text = "\(numberString((recordModel.saveRecords[indexPath.row].distance)/1000)) km"
        //        cell.durationLabel.text = "\(timerString(recordModel.saveRecords[indexPath.row].duration))"
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = recordModel.fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].name
        } else { return nil }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HistoryCustomHeaderCell") as! HistoryCustomHeaderCell
        if let sections = recordModel.fetchedResultsController?.sections where sections.count > 0 {
            headerCell.dateLabel.text = sections[section].name
        }else {
            return nil
        }
        
        return headerCell
    }
    
    
    
    
    //MARK: Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print ("row\(indexPath.row)selected")
        
        let destinationController = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticsViewController")as! StatisticsViewController
        
        let records = recordModel.fetchedResultsController.objectAtIndexPath(indexPath) as! Records
        
        guard
            let timestemp = records.timestamp,
            let distance = records.distance as? Double,
            let calories = records.calories as? Double,
            let duration = records.duration as? Double,
            let averageSpeed = records.averageSpeed as? Double,
            let locationSet = records.location
        
            else {
                print("[StaticsViewController](fetchRecordsCoreData) can't get Records")
                return}
        
        var locationList = [Locations]()  // put array inside the function rather than public to avoid appending previous data
        
        guard let loctionArray = locationSet.array as? [Location]
            
            else {
                print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
                return }
        
        for location in loctionArray {
            
            guard
                let latitude = location.latitude as? Double,
                let longitude = location.longitude as? Double
                
                else {
                    print("[StaticsViewController](fetchRecordsCoreData) can't get latitude and logitude");
                    continue}
            
            locationList.append(
                Locations(latitude: latitude, longitude: longitude))
        
        }
        
            destinationController.timestamp = timestemp
            destinationController.distance = distance
            destinationController.calories = calories
            destinationController.averageSpeed = averageSpeed
            destinationController.duration = duration
            destinationController.locations = locationList
                
                //        destinationController.records = recordModel.saveRecords[indexPath.row]
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
