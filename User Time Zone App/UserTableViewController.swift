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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        queryDataFromParse()
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
        
        queryTimer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "queryDataFromParse", userInfo: nil, repeats: true)
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Table View Functions
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allTimeZoneUsersDict.keys.array.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRowsInSection = self.allTimeZoneUsersDict.values.array[section].count
        return numRowsInSection
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let singleCellHeader: TimeZoneHeaderCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TimeZoneHeaderCell

        var timeZoneTime = timeZoneFormatter(allTimeZoneUsersDict.keys.array[section])

        
        singleCellHeader.timeInTimeZoneLabel.text = timeZoneTime
        singleCellHeader.timeZoneHeaderLabel.text = allTimeZoneUsersDict.keys.array[section]
        singleCellHeader.numberOfUsersInTimeZoneLabel.text = "\(self.allTimeZoneUsersDict.values.array[section].count) Users"
        
        singleCellHeader.separatorInset.top = 0.0
        singleCellHeader.separatorInset.bottom = 0.0
        
        return singleCellHeader
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let singleCellUser: TimeZoneUserCell = tableView.dequeueReusableCellWithIdentifier("userCell") as! TimeZoneUserCell
        
        var sectionTitles : String =  allTimeZoneUsersDict.keys.array[indexPath.section]

        var secTitles = allTimeZoneUsersDict[sectionTitles]!
        var userNames = secTitles[indexPath.row]
        
        
        var initials = convertFullNameToInitials(userNames)
        
        
        singleCellUser.userInitialAvatar.setTitle(initials, forState: .Normal)
        
        singleCellUser.userInTimeZoneLabel.text = userNames
            
        return singleCellUser

    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
        
    }
    
    
    
    //MARK: Query Functions
    
    func queryDataFromParse() {
        
        clockTimer?.invalidate()
        
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
                
                /**reload the table**/
                self.updateTableView()
                
                
                self.clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
                
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
   
    func convertFullNameToInitials(fullName: String)-> String {
        
        var fullNameArr = fullName.componentsSeparatedByString(" ")
        var firstName = fullNameArr[0] as String
        var lastName = fullNameArr[1] as String
        var firstInitial = firstChar(firstName).uppercaseString
        var lastInitial = firstChar(lastName).uppercaseString
        var initials = firstInitial + lastInitial
        
        return initials
    }
    
    func firstChar(str:String) -> String {
        return String(Array(str)[0])
    }
}
