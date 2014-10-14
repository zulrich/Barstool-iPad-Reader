//
//  Blog.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/24/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import Foundation

class Blog {
    
    var author: String
    var risque: Bool
    var permalink:String
    var blogTitle:String
    var postDate:String
    var postContent:String
    var commentStatus:String
    var thumbNail:String
    var blogId:NSNumber
    var story_id:String
    
    init(dict:NSDictionary)
    {
        self.author = dict["user_nicename"] as String
        self.risque = dict["risque"] as Bool
        self.permalink = dict["permalink"] as String
        self.blogTitle = dict["post_title"] as String
        self.postContent = dict["post_content"] as String
        self.postDate = dict["post_date"] as String
        self.commentStatus = dict["comment_status"] as String
        self.thumbNail = dict["thumbnail"] as String
        self.blogId = dict["blog_id"] as NSNumber
        self.story_id = dict["ID"] as String
    }
}