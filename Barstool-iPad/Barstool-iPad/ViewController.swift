//
//  ViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/16/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, SwipeViewDataSource,SwipeViewDelegate,BlogViewDelegate, UIPopoverControllerDelegate, ADBannerViewDelegate {

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        self.receivedData = NSMutableData();
        self.receivedResponse = NSMutableArray();
       // self.webView = UIWebView();
        self.bannerIsVisible = false
        super.init(coder: aDecoder);
    }
    
    @IBOutlet var swipeView: SwipeView!
    var receivedData: NSMutableData;
    var receivedResponse:NSMutableArray;
    var adBanner:ADBannerView!
    var bannerIsVisible:Bool
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var popover:UIPopoverController!
    //var selectedBlog:Blog?
    var blogIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.receivedData = NSMutableData()
        self.receivedResponse = NSMutableArray()
        self.adBanner = ADBannerView(frame: CGRectMake(0, self.view.frame.height, 0, 66))
        self.adBanner.delegate = self
        self.view.addSubview(self.adBanner)
        self.bannerIsVisible = false
        //self.webView = UIWebView(frame: self.view.frame)
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        if(!self.bannerIsVisible)
        {
            UIView.animateWithDuration(0.25, animations: {
                
                banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                self.swipeView.frame = CGRectOffset(self.swipeView.frame, 0, -banner.frame.size.height)
            })
            
            self.bannerIsVisible = true
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        if(self.bannerIsVisible)
        {
            UIView.animateWithDuration(0.25, animations: {
                banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
                self.swipeView.frame = CGRectOffset(self.swipeView.frame, 0, banner.frame.size.height)
            })
            
            self.bannerIsVisible = false
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        
        let transitionToWide = size.width > size.height
        
        if(transitionToWide)
        {
            
            if(bannerIsVisible)
            {
                adBanner.frame = CGRectMake(0, size.height - adBanner.frame.height, 1024, adBanner.frame.height)
                self.swipeView.frame = CGRectOffset(self.swipeView.frame, 0, -adBanner.frame.height)
                
            }
            
            
        }
        else
        {
            if(bannerIsVisible)
            {
                adBanner.frame = CGRectMake(0, size.height - adBanner.frame.height, 768, adBanner.frame.height)
                self.swipeView.frame = CGRectOffset(self.swipeView.frame, 0, -adBanner.frame.height)
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("selected blog index \(blogIndex)")
        
        
        if(blogIndex == 0)
        {
            if(self.swipeView.currentItemView == nil)
            {
                
                self.swipeView.reloadItemAtIndex(0)
            }
            
            //var curBlog = self.swipeView.currentItemView as BlogView
//
            //curBlog.showABlog(BlogManager.sharedInstance.blogs.objectAtIndex(0) as Blog)
            self.swipeView.scrollToItemAtIndex(blogIndex!, duration: 0.1)
        }
        else if(blogIndex > 0)
        {
            self.swipeView.scrollToItemAtIndex(blogIndex!, duration: 0.1)

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        return BlogManager.sharedInstance.blogs.count
    }
    

    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, reusingView reuseView: UIView!) -> UIView! {
        
                
        if(self.swipeView != nil)
        {
            var retView:BlogView
            if(reuseView == nil)
            {
                
                retView = NSBundle.mainBundle().loadNibNamed("BlogView", owner: self, options: nil).last as BlogView
                
                retView.frame = self.swipeView.bounds
                
                if(index == 0)
                {
                    retView.showABlog(BlogManager.sharedInstance.blogs.objectAtIndex(index) as Blog)
                }
                //retView = BlogView(frame: self.view.bounds)
            }
            else
            {
                retView = reuseView as BlogView
            }
            
            //retView.showABlog(BlogManager.sharedInstance.blogs.objectAtIndex(index) as Blog)
            
            retView.delegate = self
            
            return retView
        }

        
        return nil
    }
    
    func linkNavRequested(request: NSURLRequest) {
        
        self.performSegueWithIdentifier("webNavSegue", sender: request)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "webNavSegue")
        {
            var webNavVC:WebNavViewController = segue.destinationViewController as WebNavViewController
            
            webNavVC.initalRequest = sender as NSURLRequest
        }
        else if(segue.identifier == "commentSegue")
        {
        
            var commentVC:CommentsViewController = segue.destinationViewController as CommentsViewController
            
            var selectedBlog = BlogManager.sharedInstance.blogs.objectAtIndex(swipeView.currentItemIndex) as Blog
            
            commentVC.selectedStoryID = selectedBlog.story_id
            commentVC.blogID = selectedBlog.blogId.stringValue
        }
    }

    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView!) {

        println("changed \(swipeView.currentItemIndex)");
        
        var curBlog = swipeView.currentItemView as BlogView

        self.blogIndex = swipeView.currentItemIndex
        curBlog.webView.hidden = true
        curBlog.showABlog(BlogManager.sharedInstance.blogs.objectAtIndex(self.blogIndex!) as Blog)
        
    }
    
    @IBAction func handleShareTapped(sender: AnyObject) {
     
        if(self.popover != nil)
        {
            self.dismissPopover()
            return
        }

        self.popover = UIPopoverController(contentViewController: self.activityViewControllerForSharing())
        self.popover.delegate = self
        self.popover.presentPopoverFromBarButtonItem(self.shareButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    func dismissPopover()
    {
        
        var activityViewController = self.activityViewControllerForSharing()
        if (self.popover != nil) {
            self.popover.dismissPopoverAnimated(true)
            self.popover = nil
        }
    }
    
    func activityViewControllerForSharing() -> UIActivityViewController
    {
        var blog = BlogManager.sharedInstance.blogs.objectAtIndex(blogIndex!) as Blog
        
        var activityItems:NSMutableArray = NSMutableArray()
        
        var blogDict:NSMutableDictionary = NSMutableDictionary()
        
        //blogDict.setObject(blog.permalink, forKey: "permalink")
        blogDict.setObject(blog.blogTitle, forKey: "blogTitle")
        
        activityItems.addObject(blog.permalink)
        activityItems.addObject(blogDict)

        
        var activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.title = "Hi There"
        
        return activityVC
    }
    
    /*
    - (UIActivityViewController *)activityViewControllerForSharing
    {
    NSString *title = self.post.postTitle;
    NSString *summary = self.post.summary;
    NSString *tags = self.post.tags;
    
    NSMutableArray *activityItems = [NSMutableArray array];
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    
    if (title) {
    postDictionary[@"title"] = title;
    }
    if (summary) {
    postDictionary[@"summary"] = summary;
    }
    if (tags) {
    postDictionary[@"tags"] = tags;
    }
    [activityItems addObject:postDictionary];
    NSURL *permaLink = [NSURL URLWithString:self.post.permaLink];
    if (permaLink) {
    [activityItems addObject:permaLink];
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[WPActivityDefaults defaultActivities]];
    if (title) {
    [activityViewController setValue:title forKey:@"subject"];
    }
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed) {
    if (!completed) {
    return;
    }
    [WPActivityDefaults trackActivityType:activityType];
    };
    return activityViewController;
    }

*/
    
    @IBAction func commentPressed(sender: AnyObject) {
        
        var blog = BlogManager.sharedInstance.blogs.objectAtIndex(blogIndex!) as Blog
        
        if(blog.commentStatus == "open")
        {
        
            self.performSegueWithIdentifier("commentSegue", sender: nil)
        }
        else
        {
            SVProgressHUD.showErrorWithStatus("Comments closed for this blog")
        }
    }

    @IBAction func closeBlog(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {
        
            println("dismiss")
        })
    }
}

