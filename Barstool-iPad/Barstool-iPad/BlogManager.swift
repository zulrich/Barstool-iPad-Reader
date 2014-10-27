//
//  BlogManager.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/24/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit



protocol BlogManagerDelegate {
    
    func blogsDone()
}

class Person: NSObject {
    let firstName: NSString
    let lastName: String
    let age: Int
    
    init(firstName: NSString, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    override var description: String {
        return "\(firstName) \(lastName)"
    }
}



class BlogManager: NSObject, NSURLConnectionDataDelegate {
    
    
    var connection: NSURLConnection
    var blogs:NSMutableArray
    var cities:NSMutableDictionary
    var cityConnection:NSURLConnection
    
    var blogData:NSMutableData
    var cityData:NSMutableData
    
    var delegate:BlogManagerDelegate?
    
    override init() {
        
        blogData = NSMutableData()
        cityData = NSMutableData()
        cityConnection = NSURLConnection()
        connection = NSURLConnection()
        blogs = NSMutableArray()
        cities = NSMutableDictionary()
    }
    
    class var sharedInstance : BlogManager {
        
    struct Static {
        
        static var onceToken : dispatch_once_t = 0
        
        static var instance : BlogManager? = nil
        
        }
        
        dispatch_once(&Static.onceToken) {
            
            Static.instance = BlogManager()
            
            
        }
        
        return Static.instance!
        
    }
    
    func getBlogs(){
        
        var today = NSDate()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        var dateStr = dateFormatter.stringFromDate(today)
        
        var blogRequestString = "userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=get-stories&version=1.13&json={\"storydate\":\"\(dateStr)\",\"property\":\"1\"}&hash=bd7b40bccca3f09b7705851a6dd85933"
        
        var blogRequest = NSMutableURLRequest(URL: NSURL(string:"http://www.barstoolsports.com/wp-content/plugins/json-generate/get.php"));
        
        blogRequest.HTTPBody = blogRequestString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        blogRequest.HTTPMethod = "POST";
        
        self.connection = NSURLConnection(request: blogRequest, delegate: self);
        
        
        
    }
    
    func getBlogsForId(blogId:String) -> NSMutableArray
    {
        
        if(blogId == "100")
        {
            return blogs
        }
        else
        {
    
            //var:blogNum = NSNumber(int:blogId.toInt())
            
            //var blg = NSNumber(int: blogId.toInt())
            
            let idPred = NSPredicate(format: "author = %@", "feitelberg")
            
            var retBlogs = self.blogs.filteredArrayUsingPredicate(idPred)
            
            
            
//            let alice = Person(firstName: "Alice", lastName: "Smith", age: 24)
//            let bob = Person(firstName: "Bob", lastName: "Jones", age: 27)
//            let charlie = Person(firstName: "Charlie", lastName: "Smith", age: 33)
//            let quentin = Person(firstName: "Quentin", lastName: "Alberts", age: 31)
//            //var people = [alice, bob, charlie, quentin]
//            
//            var people = NSMutableArray(objects: alice, bob, charlie,quentin)
//            
//            let bobPredicate = NSPredicate(format: "firstName != %@", "aaab")
//            //let smithPredicate = NSPredicate(format: "lastName = %@", "Smith")
//            //let thirtiesPredicate = NSPredicate(format: "age >= 30")
//            
//            
//            
//            var x = people.filteredArrayUsingPredicate(bobPredicate)
//            // ["Bob Jones"]
//            
//            //var y = people.filteredArrayUsingPredicate(smithPredicate)
//            // ["Alice Smith", "Charlie Smith"]
//            
//            //var z = people.filteredArrayUsingPredicate(thirtiesPredicate)
//            // ["Charlie Smith", "Quentin Alberts"]
            
            
            
        
            return NSMutableArray(array: retBlogs)
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        self.blogData.appendData(data)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println(error)
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        parseBlogs(self.blogData)
    }
    
    func parseBlogs(data:NSMutableData)
    {
        var error: NSError?;
        
        if(data.length == 0)
        {
            println("Didn't get blogs")
            return
        }
        
        var responseArr: NSMutableArray? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableArray;
        
        if(error == nil)
        {
            
        }
        
        
        var storyLevel:NSArray = responseArr?.objectAtIndex(1).objectAtIndex(1) as NSArray
        
        var storiesArr = NSMutableArray()
        
        for(var i = 0; i < storyLevel.count; i++)
        {
            storiesArr.addObjectsFromArray(storyLevel.objectAtIndex(i).objectForKey("stories") as NSArray)
        }
        
        for(var i = 0; i < storiesArr.count; i++){
            
            var blog = Blog(dict: storiesArr.objectAtIndex(i) as NSDictionary)
            
            self.blogs.addObject(blog)
        }
        
        self.blogData = NSMutableData()
        delegate?.blogsDone()
        
        
    }
   
}
