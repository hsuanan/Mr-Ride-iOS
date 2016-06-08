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

    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        print ("HistoryPage : SideBarButtonTapped")
    }
    
    var testArray = ["test1","test2","test3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HistoryViewDidLoad")

    
        let nib = UINib(nibName: "HistoryTableViewCell" , bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.distanceLabel.text = "\(testArray[indexPath.row]) Km"
        
        
        return cell
    }
    
//    func fetchRecordsCoreData(){
//        
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Records")
//        
//        do {
//            let fetchedRecords = try moc.executeFetchRequest(fetchRequest) as! [Records]
//            
//            
//        } catch {
//            let fetchError = error as NSError
//            print("fetchError:\(fetchError)")
//        }
//    }
    

    
    


    


}
