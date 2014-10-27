//
//  BlogColors.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/1/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import Foundation
import UIKit

let bosBlog = ["id": "2", "name": "boston", "color" : "0xA10000"]
let nyBlog = ["id": "3", "name": "new york city", "color" : "0x333333"]
let philBlog = ["id": "4", "name": "philly", "color" : "0x1E6D57"]
let barstoolUBlog = ["id": "5", "name": "barstoolu", "color" : "0x003366"]
let chiBlog = ["id": "7", "name": "chicago", "color" : "0xF17220"]
let dmvBlog = ["id": "10", "name": "dmv", "color" : "0x004967"]
let iowaBlog = ["id": "12", "name": "iowa", "color" : "0xE9CE23"]


let blogColors = ["2" : "#A10000", "3" : "#333333", "4" : "#1E6D57", "5" : "#003366", "7" : "#F17220", "10" : "#004967", "12" : "#E9CE23"]

let blogNameDict = ["Boston" : "2", "New York City" : "3", "Philly" : "4", "BarstoolU" : "5", "Chicago": "7", "DMV" : "10", "Iowa" : "12" , "Super Page" : "100"]


class BlogColors {
    
    class func getColor(blogId:String) -> UIColor
    {
        var blogColor = blogColors[blogId]
        
        return UIColor(rgba: blogColor!)
        
    }
    
    class func getBlogId(blogName:String) -> String
    {
        return blogNameDict[blogName]!
    }
    

}
