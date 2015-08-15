//
//  ViewController.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/13/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit
import Parse


class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userCurrentTimeZoneLabel: UILabel!
    
    @IBOutlet weak var timeZonePickerViewContainer: UIView!
    
    @IBOutlet weak var timeZonePicker: UIPickerView!
    
    @IBOutlet weak var userTableView: UITableView!
    
    var allTimeZoneUsersDict = [String :[String]]()
    
    var activeTimeZones = [String]()
    
    var usersInTimeZone = [String]()
    
    var clock = TimeDisplay()
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        getCurrentUserTimeZoneFromParse()
        queryDataFromParse()
        
        self.timeZonePickerViewContainer.hidden = true
        self.timeZonePicker.delegate = self
        self.timeZonePicker.dataSource = self
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //check if a user is logged in. if not show login view
        if (PFUser.currentUser() == nil) {
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: Functions
    
    //Retreives the current users time zone (used when view loads)
    func getCurrentUserTimeZoneFromParse() -> String! {
        
        if PFUser.currentUser() == nil {
            return nil
        }
        var timeZoneFromParse = PFUser.currentUser()!["timeZone"] as? String
        
        self.userCurrentTimeZoneLabel.text = timeZoneFromParse
        
        return timeZoneFromParse
    }
    
    //updates table view
    func updateTableView(){
        
        self.userTableView.reloadData()
        
    }
    
    //function to remove duplicate items from array
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    
    
    //MARK: Actions
    
    //logout button
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("login", sender: self)
    }
    
    //Brings up picker view container
    @IBAction func changeTimeZoneButton(sender: AnyObject) {
        
        self.timeZonePickerViewContainer.hidden = false
        
        
    }
    
    
    @IBAction func cancelChangeTimeZoneButton(sender: UIButton) {
        
        getCurrentUserTimeZoneFromParse()
        self.timeZonePickerViewContainer.hidden = true
        
    }
    
    
    //Updates user timezone with selection from picker and hides picker on exit
    @IBAction func updateUserTimeZone(sender: AnyObject) {
        
        let newTimeZone = userCurrentTimeZoneLabel.text
        let user = PFUser.currentUser()
        user?.setObject(newTimeZone!, forKey: "timeZone")
        user?.saveInBackgroundWithBlock {(succeeded, error) -> Void in
            if succeeded {
                //alert succeed
                var alert = UIAlertView(title: "Update Succeeded", message: "Your Time Zone Has Been Updated", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
                /**reload UITableView**/
                //self.userTableView.reloadData()
                self.queryDataFromParse()
                
            }else {
                //alert failed
                var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
        self.timeZonePickerViewContainer.hidden = true
        
    }
    
    
    
    //MARK: Time Zone Finder
    
    //Get user local time zone
    func localTimeZoneName() -> String {
        return NSTimeZone.localTimeZone().name
    }
    
    
    
    //MARK: Time Zone Picker
    
    //grabs dictionary of all time zone abreviations
    func timeZoneDictionary() -> [String:String] {
        return NSTimeZone.abbreviationDictionary() as! [String:String]
    }
    
    //create new array out of values of time zone dictionary and sort the values alphabetically
    func timeZoneNamesArray() -> [String] {
        
        var tzArray: [String] = timeZoneDictionary().values.array
        var uniqueTzValues = uniq(tzArray)
        return sorted(uniqueTzValues)
    }
    
    //Picker Functions
    //set number of columns for picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //set number of rows for picker from the timeZonesArray
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return timeZoneNamesArray().count
    }
    
    //set the value of each row of picker from the timeZonesArray
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return timeZoneNamesArray()[row]
    }
    
    //set the chosen row to the new value in label
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        userCurrentTimeZoneLabel.text = timeZoneNamesArray()[row]
        
    }
    
    
    
    //MARK: Table View Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        
        let dictionaryKeys = self.allTimeZoneUsersDict.keys.array
        
        return dictionaryKeys.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let singleCellHeader: TimeZoneCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TimeZoneCell
        
        let singleCellUser: TimeZoneCell = tableView.dequeueReusableCellWithIdentifier("userCell") as! TimeZoneCell
        
        let timeZoneFromDictionary = self.allTimeZoneUsersDict.keys.array
        
        let userFromDictionary = self.allTimeZoneUsersDict.values.array
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        timeFormatter.timeZone = NSTimeZone(name: timeZoneFromDictionary[indexPath.row])
        
        
        var formattedTime = timeFormatter.stringFromDate(clock.currentTime)
        
        singleCellHeader.timeInTimeZoneLabel.text = formattedTime
        
        singleCellHeader.timeZoneHeaderLabel.text = timeZoneFromDictionary[indexPath.row]
        
        
        
        return singleCellHeader
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
                
                /**reload the table**/
                self.updateTableView()
                
            }else {
                
                NSLog("Error: %@ $@", error!, error!.userInfo!)
            }
            
        })
    }
    
    
    
}