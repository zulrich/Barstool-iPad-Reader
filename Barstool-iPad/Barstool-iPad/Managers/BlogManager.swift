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

class BlogManager: NSObject, NSURLConnectionDataDelegate {
    
    
    var connection: NSURLConnection
    var blogs:NSMutableArray
    var cities:NSMutableDictionary
    var cityConnection:NSURLConnection
    var blogsToShow:NSArray
    
    var blogData:NSMutableData
    var cityData:NSMutableData
    
    var delegate:BlogManagerDelegate?
    
    override init() {
        
        blogsToShow = NSArray()
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
        
        var blogRequest:NSMutableURLRequest! = NSMutableURLRequest(URL: NSURL(string:"http://www.barstoolsports.com/wp-content/plugins/json-generate/get.php")!);
        
        blogRequest.HTTPBody = blogRequestString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        blogRequest.HTTPMethod = "POST";
        
        self.connection = NSURLConnection(request: blogRequest, delegate: self)!;
        
    }
    
    func getBlogsForId(blogId:String)
    {
        
        if(blogId == "100")
        {
             blogsToShow = blogs
        }
        else
        {
    
            var intV = blogId.toInt()
            
            let idPred = NSPredicate(format: "blogId = %@", blogId)
            
            var retBlogs = self.blogs.filteredArrayUsingPredicate(idPred!)
            
            blogsToShow = retBlogs
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
            SVProgressHUD.show()
            
            self.getBlogs()
            println("Didn't get blogs \(error)")
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
        
        SVProgressHUD.dismiss()
        
        
    }
   
}
