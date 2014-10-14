//
//  Comment.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/3/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import Foundation

//comment request example   userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=get-comments&version=1.13&json={"property":"10","story_id":"32242"}&hash=8c2deca9756468a98648125206f776bb


class Comment {
    
    var commenterName:String
    var commentDate:String
    var commentID:String
    var upCount:NSNumber
    var downCount:NSNumber
    var commenterEmail:String
    var commentContent:String
    
    
    init(dict:NSDictionary)
    {
        self.commenterName = dict["user_nicename"] as String
        self.commentDate = dict["comment_date"] as String
        self.commentID = dict["comment_ID"] as String
        self.upCount = dict["vote_up"] as NSNumber
        self.downCount = dict["vote_down"] as NSNumber
        self.commenterEmail = dict["comment_author_email"] as String
        self.commentContent = dict["comment_content"] as String
    }
    
    init()
    {
        self.commenterName = ""
        self.commentDate = ""
        self.commentContent = ""
        self.upCount = NSNumber(int:0)
        self.downCount = NSNumber(int: 0)
        self.commenterEmail = ""
        self.commentID = ""
    }
    
}