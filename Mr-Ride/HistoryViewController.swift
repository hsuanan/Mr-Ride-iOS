//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 5/29/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit
import CoreData

struct SavedRecords {
    
    var timestamp = NSDate()
    var distance = 0.0
    var calories = 0.0
    var duration = 0.0
    var averageSpeed = 0.0
    
}


class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        print ("HistoryPage : SideBarButtonTapped")
    }
        
    var saveRecords = [SavedRecords]()
    
    var locationList = [Locations]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HistoryViewDidLoad")
        
        setup()
        
        let nib = UINib(nibName: "HistoryTableViewCell" , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.dataSource = self  // 或這是從storyboard拉tableview到controller選擇dataSource
        tableView.delegate = self   // 或這是從storyboard拉tableview到controller選擇delegate
        
        fetchRecordsCoreData()
        
    }
    //MARK: CoreData
    
    func fetchRecordsCoreData(){
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let date = NSDate()
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", date )
        fetchRequest.fetchBatchSize = 10
        //        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
            
            print("fetchedRecords: \(fetchedRecords)")
            
            for eachFetchedRecord in fetchedRecords {
                
                guard let locationSet = eachFetchedRecord.location
                    else {
                        print("[StaticsViewController](fetchRecordsCoreData) can't get locationSet");
                        return}
                
                guard let loctionArray = locationSet.array as? [Location]
                    
                    else {
                        print("[StaticsViewController](fetchRecordsCoreData) can't get locationArray");
                        return }
                
                for location in loctionArray {
                    
                    print("latitude:\(location.latitude) longitude:\(location.longitude)")
                    
                    guard
                        let latitude = location.latitude as? Double,
                        let longitude = location.longitude as? Double
                        
                        else {
                            print("[StaticsViewController](fetchRecordsCoreData) can't get latitude and logitude");
                            continue}
                    locationList.append(
                        Locations(latitude: latitude, longitude: longitude))
                    
                }
                
                guard
                    let timestemp = eachFetchedRecord.timestamp,
                    let distance = eachFetchedRecord.distance as? Double,
                    let calories = eachFetchedRecord.calories as? Double,
                    let duration = eachFetchedRecord.duration as? Double,
                    let averageSpeed = eachFetchedRecord.averageSpeed as? Double
                    
                    else {
                        print("[StaticsViewController](fetchRecordsCoreData) can't get Records");
                        continue }
                
                saveRecords.append(
                    SavedRecords(
                        timestamp: timestemp,
                        distance: distance,
                        calories: calories,
                        duration: duration,
                        averageSpeed: averageSpeed))
            }
            
        } catch {
            let fetchError = error as NSError
            print("fetchError:\(fetchError)")
        }
    }
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saveRecords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.dateLabel.text = "\(dateString(saveRecords[indexPath.row].timestamp))"
        cell.distanceLabel.text = "\(numberString((saveRecords[indexPath.row].distance)/1000)) km"
        cell.durationLabel.text = "\(timerString(saveRecords[indexPath.row].duration))"
        
        return cell
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
