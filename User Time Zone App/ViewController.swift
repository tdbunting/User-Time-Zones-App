//
//  ViewController.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/13/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit
import Parse


class MainViewController: UIViewController {

    @IBOutlet weak var userCurrentTimeZoneLabel: UILabel!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.userCurrentTimeZoneLabel.text = localTimeZoneName()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            
            self.performSegueWithIdentifier("custom", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //MARK: Actions
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("custom", sender: self)
    }
    
    
    
    
    //MARK: Time Zone Finder
    
    
    func localTimeZoneName() -> String {
        return NSTimeZone.localTimeZone().name
    }
    
    
}


