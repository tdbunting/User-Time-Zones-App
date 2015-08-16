//
//  TimeZoneCell.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/15/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit

class TimeZoneHeaderCell: UITableViewCell {
    
    
    
    @IBOutlet weak var timeZoneHeaderLabel: UILabel!

    @IBOutlet weak var numberOfUsersInTimeZoneLabel: UILabel!
    
    @IBOutlet weak var timeInTimeZoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated:animated)
        
        
        //Configure View for selected State
        
    }


}

class TimeZoneUserCell: UITableViewCell {
    
    
    @IBOutlet weak var userInTimeZoneLabel: UILabel!
    
    
    @IBOutlet weak var userInitialAvatar: UserAvatar!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //init code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated:animated)
        
        //Configure View for selected State
        
    }
    
    
}
