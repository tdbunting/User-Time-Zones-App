//
//  TimeZoneCell.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/15/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit

class TimeZoneCell: UITableViewCell {
    
    //@IBOutlet weak var timeZoneHeaderCell: UIView!
    
    @IBOutlet weak var timeZoneHeaderLabel: UILabel!

    @IBOutlet weak var timeInTimeZoneLabel: UILabel!
    
    //@IBOutlet weak var userInTimeZoneCell: UIView!
    
    @IBOutlet weak var userInTimeZoneLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //init code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated:animated)
    
        //Configure View for selected State
        
    }


}
