//
//  UserTableViewController.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/15/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController, UITableViewDelegate {
    
    @IBOutlet weak var userTableView: UITableView!

    var allTimeZoneUsersDict = [String : [String]]()
    
    var activeTimeZones = [String]()
    
    var usersInTimeZone = [String]()
    
    var clock = TimeDisplay()
    
    var timer: NSTimer?
    
    var sectionTimeZone = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryDataFromParse()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Table View Functions
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTimeZone.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRowsInSection = self.allTimeZoneUsersDict.values.array[section].count
        return numRowsInSection
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let singleCellHeader: TimeZoneHeaderCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TimeZoneHeaderCell

        var timeZoneTime = timeZoneFormatter(sectionTimeZone[section])
        
        singleCellHeader.timeInTimeZoneLabel.text = timeZoneTime
        singleCellHeader.timeZoneHeaderLabel.text = sectionTimeZone[section]
        singleCellHeader.numberOfUsersInTimeZoneLabel.text = "\(self.allTimeZoneUsersDict.values.array[section].count) Users"
        
        return singleCellHeader
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var sectionTitle: String = sectionTimeZone[indexPath.section]
        var secTitles = self.allTimeZoneUsersDict[sectionTitle]!
        var timeZoneTime = timeZoneFormatter(sectionTimeZone[indexPath.row])
        
        /*
        println(sectionTitle)
        
        if  {
            
            println("section 0 hit")
            let singleCellHeader: TimeZoneHeaderCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TimeZoneHeaderCell
            
            singleCellHeader.timeInTimeZoneLabel.text = timeZoneTime
            singleCellHeader.timeZoneHeaderLabel.text = sectionTimeZone[indexPath.row]
            singleCellHeader.numberOfUsersInTimeZoneLabel.text = "\(self.allTimeZoneUsersDict.values.array[indexPath.row].count) Users"
            
            return singleCellHeader
            
        }else {
           */
            println("user section hit")
            
            let singleCellUser: TimeZoneUserCell = tableView.dequeueReusableCellWithIdentifier("userCell") as! TimeZoneUserCell
            
            singleCellUser.userInTimeZoneLabel.text = secTitles[indexPath.row]
            
            return singleCellUser
        
        //}
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 45
        
    }
    
    
    
    //MARK: Query Functions
    
    func queryDataFromParse() {
        
        self.allTimeZoneUsersDict = [String:[String]]()
        
        var query = PFQuery(className: "_User")
        
        query.orderByDescending("timeZone")
        
        query.findObjectsInBackgroundWithBlock({
            (object, error) -> Void in
            
            if error == nil {
                //self.allTimeZoneUsersDict = [String:[String]]()
                for item in object! {
                    
                    let name = item["displayName"] as! String
                    let timeZone = item["timeZone"]as! String
                    
                    //if time zone key already exists, copy array, append new name and add new array to dictionary
                    if self.allTimeZoneUsersDict .has(timeZone){
                        
                        var oldArray = self.allTimeZoneUsersDict[timeZone]!
                        
                        oldArray.append(name)
                        
                        self.allTimeZoneUsersDict[timeZone] = oldArray
                        
                        //else add element to dictionary
                    }else{
                        
                        self.allTimeZoneUsersDict[timeZone] = [name]
                        
                    }
                }
                
                println("\(self.allTimeZoneUsersDict.keys.array.count) active Time Zones")
                var flattened = self.allTimeZoneUsersDict.values.array.reduce([], combine: +)
                println("\(flattened.count) active Users")
                println("\(self.allTimeZoneUsersDict)")
                
                self.sectionTimeZone = [String](self.allTimeZoneUsersDict.keys.array)
                
                
                /**reload the table**/
                self.updateTableView()
                
            }else {
                
                NSLog("Error: %@ $@", error!, error!.userInfo!)
            }
            
        })
    }
    
    
    
    //MARK: Functions
    
    //updates table view
    func updateTableView(){
        
        self.userTableView.reloadData()
        
    }
    
    func timeZoneFormatter(timeZone: String) -> String{
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        timeFormatter.timeZone = NSTimeZone(name: timeZone)
        var formattedTime = timeFormatter.stringFromDate(clock.currentTime)
        
        return formattedTime
    }
   
    
}
