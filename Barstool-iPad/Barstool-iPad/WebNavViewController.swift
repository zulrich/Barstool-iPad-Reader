//
//  WebNavViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/8/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

class WebNavViewController: UIViewController, UIWebViewDelegate, UIPopoverControllerDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var forwardButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var initalRequest:NSURLRequest!
    var popover:UIPopoverController!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.webView = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.forwardButton.enabled = false
        self.backButton.enabled = false
        
        self.webView.loadRequest(self.initalRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.forwardButton.enabled = webView.canGoForward
        self.backButton.enabled = webView.canGoBack
    }
    
    @IBAction func forwardPressed(sender: AnyObject) {
        
        if(self.webView.canGoForward)
        {
            self.webView.goForward()
        }
    }

    @IBAction func backPressed(sender: AnyObject) {
        
        if(self.webView.canGoBack)
        {
            self.webView.goBack()
        }
    }

    @IBAction func refreshPressed(sender: AnyObject) {
        
        self.webView.reload()
    }

    @IBAction func donePressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {})
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
       // var blog = BlogManager.sharedInstance.blogs.objectAtIndex(blogIndex!) as Blog
        
        var activityItems:NSMutableArray = NSMutableArray()
        
        var webDict:NSMutableDictionary = NSMutableDictionary()
        
        //blogDict.setObject(blog.permalink, forKey: "permalink")
        //webDict.setObject(blog.blogTitle, forKey: "blogTitle")
        
//        activityItems.addObject(self.webView.request.URL.absoluteURL)
        //activityItems.addObject(blogDict)
        
        
        var activityVC = UIActivityViewController(nibName: nil, bundle: nil)
//
//        activityVC.title = "Hi There"
        
        return activityVC
    }
    
}
