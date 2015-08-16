
//
//  DictionaryExtension.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/15/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import Foundation
import Swift

internal extension Dictionary {
    
    
    /**
    Checks if a key exists in the dictionary.
    
    :param: key Key to check
    :returns: true if the key exists
    */
    func has (key: Key) -> Bool {
        return indexForKey(key) != nil
    }
    
    /**
    Creates an Array with values generated by running
    each [key: value] of self through the mapFunction.
    
    :param: mapFunction
    :returns: Mapped array
    */
    func toArray <V> (map: (Key, Value) -> V) -> [V] {
        
        var mapped = [V]()
        
        each {
            mapped.append(map($0, $1))
        }
        
        return mapped
        
    }
    
    /**
    Creates a Dictionary with the same keys as self and values generated by running
    each [key: value] of self through the mapFunction.
    
    :param: mapFunction
    :returns: Mapped dictionary
    */
    func mapValues <V> (map: (Key, Value) -> V) -> [Key: V] {
        
        var mapped = [Key: V]()
        
        each {
            mapped[$0] = map($0, $1)
        }
        
        return mapped
        
    }
    
    /**
    Creates a Dictionary with the same keys as self and values generated by running
    each [key: value] of self through the mapFunction discarding nil return values.
    
    :param: mapFunction
    :returns: Mapped dictionary
    */
    func mapFilterValues <V> (map: (Key, Value) -> V?) -> [Key: V] {
        
        var mapped = [Key: V]()
        
        each {
            if let value = map($0, $1) {
                mapped[$0] = value
            }
        }
        
        return mapped
        
    }
    
    /**
    Creates a Dictionary with keys and values generated by running
    each [key: value] of self through the mapFunction discarding nil return values.
    
    :param: mapFunction
    :returns: Mapped dictionary
    */
    func mapFilter <K, V> (map: (Key, Value) -> (K, V)?) -> [K: V] {
        
        var mapped = [K: V]()
        
        each {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        
        return mapped
        
    }
    
    /**
    Creates a Dictionary with keys and values generated by running
    each [key: value] of self through the mapFunction.
    
    :param: mapFunction
    :returns: Mapped dictionary
    */
    func map <K, V> (map: (Key, Value) -> (K, V)) -> [K: V] {
        
        var mapped = [K: V]()
        
        self.each({
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        })
        
        return mapped
        
    }
    
    /**
    Loops trough each [key: value] pair in self.
    
    :param: eachFunction Function to inovke on each loop
    */
    func each (each: (Key, Value) -> ()) {
        
        for (key, value) in self {
            each(key, value)
        }
        
    }
    
    /**
    Constructs a dictionary containing every [key: value] pair from self
    for which testFunction evaluates to true.
    
    :param: testFunction Function called to test each key, value
    :returns: Filtered dictionary
    */
    func filter (test: (Key, Value) -> Bool) -> Dictionary {
        
        var result = Dictionary()
        
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        
        return result
        
    }
    
    /**
    Creates a dictionary composed of keys generated from the results of
    running each element of self through groupingFunction. The corresponding
    value of each key is an array of the elements responsible for generating the key.
    
    :param: groupingFunction
    :returns: Grouped dictionary
    */
    func groupBy <T> (group: (Key, Value) -> T) -> [T: [Value]] {
        
        var result = [T: [Value]]()
        
        for (key, value) in self {
            
            let groupKey = group(key, value)
            
            // If element has already been added to dictionary, append to it. If not, create one.
            if result.has(groupKey) {
                result[groupKey]! += [value]
            } else {
                result[groupKey] = [value]
            }
            
        }
        
        return result
    }
    
    /**
    Similar to groupBy. Doesn't return a list of values, but the number of values for each group.
    
    :param: groupingFunction Function called to define the grouping key
    :returns: Grouped dictionary
    */
    func countBy <T> (group: (Key, Value) -> (T)) -> [T: Int] {
        
        var result = [T: Int]()
        
        for (key, value) in self {
            
            let groupKey = group(key, value)
            
            // If element has already been added to dictionary, append to it. If not, create one.
            if result.has(groupKey) {
                result[groupKey]!++
            } else {
                result[groupKey] = 1
            }
        }
        
        return result
    }
    
    /**
    Checks if test evaluates true for all the elements in self.
    
    :param: test Function to call for each element
    :returns: true if test returns true for all the elements in self
    */
    func all (test: (Key, Value) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if !test(key, value) {
                return false
            }
        }
        
        return true
        
    }
    
    /**
    Checks if test evaluates true for any element of self.
    
    :param: test Function to call for each element
    :returns: true if test returns true for any element of self
    */
    func any (test: (Key, Value) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if test(key, value) {
                return true
            }
        }
        
        return false
        
    }
    
    
    /**
    Returns the number of elements which meet the condition
    
    :param: test Function to call for each element
    :returns: the number of elements meeting the condition
    */
    func countWhere (test: (Key, Value) -> (Bool)) -> Int {
        
        var result = 0
        
        for (key, value) in self {
            if test(key, value) {
                result++
            }
        }
        
        return result
    }
    
    
    /**
    Recombines the [key: value] couples in self trough combine using initial as initial value.
    
    :param: initial Initial value
    :param: combine Function that reduces the dictionary
    :returns: Resulting value
    */
    func reduce <U> (initial: U, combine: (U, Element) -> U) -> U {
        return Swift.reduce(self, initial, combine)
    }
    
}