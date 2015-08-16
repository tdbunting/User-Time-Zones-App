//
//  UserAvatar.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/16/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit

class UserAvatar: UIButton {

    override func drawRect(rect: CGRect) {
        
        var path = UIBezierPath(ovalInRect: CGRectMake(5, 5, 30, 30))
        UIColor.blackColor().setStroke()
        path.lineWidth = 3
        path.stroke()
        
    
    }

}
