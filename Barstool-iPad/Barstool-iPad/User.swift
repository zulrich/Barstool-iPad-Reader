//
//  User.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/6/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import Foundation

//"user_id": 155199,
//"user_firstname": "",
//"user_lastname": "",
//"user_email": "ulrichzack@gmail.com",
//"user_login": "mrstache",
//"user_password": "gunnery",
//"risque_allowed": true,
//"avatar": "",
//"hash": "c17f212624e82256f288634e734886b5"


class User:NSObject  {
    
    var user_id:NSNumber!
    var firstName:String!
    var lastName:String!
    var email:String!
    var username:String!
    var password:String!
    var risque:Bool!
    var avatar:String!
    var hashStr:String!
    
    init(dict:NSDictionary)
    {
        super.init()
        self.user_id = dict["user_id"] as NSNumber
        self.firstName = dict["user_firstname"] as String
        self.lastName = dict["user_lastname"] as String
        self.email = dict["user_email"] as String
        self.username = dict["user_login"] as String
        self.password = dict["user_password"] as String
        self.risque = dict["risque_allowed"] as Bool
        self.avatar = dict["avatar"] as String
        self.hashStr = dict["hash"] as String
    }
}