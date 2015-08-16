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
    
    var clockTimer: NSTimer?
    
    var queryTimer: NSTimer?
    
    var sectionTimeZone = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        queryDataFromParse()
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
        
        queryTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "queryDataFromParse", userInfo: nil, repeats: true)
    

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
        
        singleCellHeader.separatorInset.top = 0.0
        singleCellHeader.separatorInset.bottom = 0.0
        
        return singleCellHeader
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //var sectionTitle: String = sectionTimeZone[indexPath.section]
        
        let singleCellUser: TimeZoneUserCell = tableView.dequeueReusableCellWithIdentifier("userCell") as! TimeZoneUserCell
        
        var sectionTitles : String =  sectionTimeZone[indexPath.section]

        var secTitles = allTimeZoneUsersDict[sectionTitles]!
        var userNames = secTitles[indexPath.row]
        
            
        singleCellUser.userInTimeZoneLabel.text = userNames
            
        return singleCellUser

    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
        
    }
    
    
    
    //MARK: Query Functions
    
    func queryDataFromParse() {
        
        clockTimer?.invalidate()
        
        //self.allTimeZoneUsersDict = [String:[String]]()
        
        var query = PFQuery(className: "_User")
        
        query.orderByDescending("timeZone")
        
        query.findObjectsInBackgroundWithBlock({
            (object, error) -> Void in
            
            if error == nil {
                self.allTimeZoneUsersDict = [String:[String]]()
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
                
                
                self.sectionTimeZone = [String](self.allTimeZoneUsersDict.keys)
                
                
                /**reload the table**/
                self.updateTableView()
                
                
                self.clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
                
                
            }else {
                
                NSLog("Error: %@ $@", error!, error!.userInfo!)
            }
            
            self.sectionTimeZone = [String](self.allTimeZoneUsersDict.keys)
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
