//
//  CommentsViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/4/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

/*
userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=add-comment&version=1.13&json={"username":"mrstache","password":"gunnery","property":"2","story_id":"211790","hash":"c17f212624e82256f288634e734886b5","comment":"Absolute genius"}&hash=76a7b74e6a9b19f1724d8e133ebdd3b5
*/

import UIKit

class CommentsViewController: UIViewController, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, InlineComposeViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectedStoryID = String()
        self.recievedData = NSMutableData()
        self.connection = NSURLConnection()
        self.comments = Array<Comment>()
        self.inlineComposeView = InlineComposeView()
    }

    @IBOutlet var tableView: UITableView!
    
    var blogID:String!
    var selectedStoryID:String!
    var recievedData:NSMutableData!
    var connection:NSURLConnection!
    var comments:Array<Comment>!
    var topComment:Comment!
    var secondComment:Comment!
    var inlineComposeView:InlineComposeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topComment = Comment()
        self.secondComment = Comment()
        
        self.inlineComposeView = InlineComposeView(frame: CGRectZero)
        self.inlineComposeView.delegate = self
        self.view.addSubview(self.inlineComposeView)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadComments()
    }
    
    func loadComments()
    {
        
        self.recievedData = NSMutableData()
        
//        var commentStr = "userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=get-comments&version=1.13&json={\"property\":\"10\",\"story_id\":\"\(self.selectedStoryID)\"}&hash=8c2deca9756468a98648125206f776bb"
        
        var commentStr = "userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=get-comments&version=1.13&json={\"property\":\"\(self.blogID)\",\"story_id\":\"\(self.selectedStoryID)\"}"
        
        println(self.selectedStoryID.md5)
        println("")
        
        var commentRequest = NSMutableURLRequest(URL: NSURL(string:"http://www.barstoolsports.com/wp-content/plugins/json-generate/get.php"));
        
        commentRequest.HTTPBody = commentStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        commentRequest.HTTPMethod = "POST";
        
        self.connection = NSURLConnection(request: commentRequest, delegate: self);
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Failed to load comments with error \(error)")
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println(response)
    }
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        println("recieved data")
        self.recievedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
     
        self.parseComments()
    }
    
    func parseComments()
    {
        var error: NSError?;
        
        if(self.recievedData.length == 0)
        {
            println("didn't receive anything")
            return
        }
        
        var responseArr: NSMutableArray? = NSJSONSerialization.JSONObjectWithData(self.recievedData, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableArray;
        
        if(error == nil)
        {
            println("error parsing \(error)")
        }
        
        var commentsArr: NSArray = responseArr?.objectAtIndex(1) as NSArray
        
        for(var i = 0; i < commentsArr.count; i++)
        {
            var comment = Comment(dict: commentsArr.objectAtIndex(i) as NSDictionary)
            
            self.comments.append(comment)
            
            
            if(comment.upCount.intValue > self.topComment.upCount.intValue)
            {
                self.secondComment = self.topComment
                self.topComment = comment
            }
            else if(comment.upCount.intValue > self.secondComment.upCount.intValue)
            {
                self.secondComment = comment
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func composeView(view: InlineComposeView!, didSendText text: String!) {
        println("Comment \(text)")
        
        self.inlineComposeView.dismissComposer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        //println("section \(section) count \(self.comments.count)" )
        
        if(section == 0)
        {
            if(self.comments.count == 0){
                return 0
            }
            else if(self.comments.count == 1){
                return 1
            }
            else if(self.comments.count >= 2){
                return 2
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            return self.comments.count
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0)
        {
            return "Top Comments"
        }
        else
        {
            return "Comments"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as CommentTableViewCell

        
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                cell.setupCell(self.topComment)
            }
            else if(indexPath.row == 1)
            {
                cell.setupCell(self.secondComment)
            }
        }
        else
        {
            cell.setupCell(self.comments[indexPath.row] as Comment)

        }
        

        return cell
    }

    @IBAction func addComment(sender: AnyObject) {
        
        
        var curUser:NSDictionary? = NSUserDefaults.standardUserDefaults().objectForKey("currentUser") as NSDictionary?
        
        if(curUser == nil)
        {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
        self.inlineComposeView.displayComposer()
    }

    @IBAction func closeComments(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: {})
    }


}
