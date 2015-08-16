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







//// General Declarations
let context = UIGraphicsGetCurrentContext()

//// Oval Drawing
let ovalRect = CGRectMake(71, 18, 40, 40)
var ovalPath = UIBezierPath(ovalInRect: ovalRect)
UIColor.blackColor().setStroke()
ovalPath.lineWidth = 3
ovalPath.stroke()
var ovalTextContent = NSString(string: "TB")
let ovalStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
ovalStyle.alignment = NSTextAlignment.Center

let ovalFontAttributes = [NSFontAttributeName: UIFont(name: "Helvetica", size: 20)!, NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: ovalStyle]

let ovalTextHeight: CGFloat = ovalTextContent.boundingRectWithSize(CGSizeMake(ovalRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: ovalFontAttributes, context: nil).size.height
CGContextSaveGState(context)
CGContextClipToRect(context, ovalRect);
ovalTextContent.drawInRect(CGRectMake(ovalRect.minX, ovalRect.minY + (ovalRect.height - ovalTextHeight) / 2, ovalRect.width, ovalTextHeight), withAttributes: ovalFontAttributes)
CGContextRestoreGState(context)