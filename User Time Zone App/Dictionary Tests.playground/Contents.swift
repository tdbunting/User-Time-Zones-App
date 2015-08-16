//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var testDict = [String : [String]]()

testDict = [
    "timezone1" : ["user1", "user2", "user3"],
    "timezone2" : ["user4", "user5"],
    "timezone3" : ["user6", "user7", "user8"]
    ]

testDict.values.array.count

struct TimeZoneObjects {
    var timeZoneName : String!
    var usersInTimeZoneName : [String]!
}

var arrayTimeZoneObjects = [TimeZoneObjects]()

for (key, value) in testDict {
    
    println(key)
    println(value)
    
}


println(arrayTimeZoneObjects)