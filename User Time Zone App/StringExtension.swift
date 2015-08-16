//
//  StringExtension.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/16/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import Foundation
import Swift

internal extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}
