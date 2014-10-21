//
//  BlogView.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/2/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit
import WebKit

protocol BlogViewDelegate {
    
    func linkNavRequested(request:NSURLRequest)
}


class BlogView: UIView, UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var blogDateLabel: UILabel!
    @IBOutlet var blogAuthorLabel: UILabel!
    @IBOutlet var blogTitleTextView: UITextView!
    
    var previousScrollViewYOffset:CGFloat!
    var linkRequest:NSURLRequest!
    
    var delegate:BlogViewDelegate?

    
//    @IBAction func goBackSwipe(sender: AnyObject) {
//        
//        println("Go back")
//        
//        if(self.webView.canGoBack)
//        {
//            self.webView.goBack()
//        }
//        
//    }
    
    override func awakeFromNib() {
 
        self.webView.delegate = self
       // self.webView.scrollView.delegate = self
        self.previousScrollViewYOffset = 0
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if(navigationType == UIWebViewNavigationType.LinkClicked)
        {
//            self.linkRequest = request
//            var av = UIAlertView(title: "Open Link", message: "Would you like to open link?", delegate: self, cancelButtonTitle: "Yes", otherButtonTitles: "Cancel")
//            
//            av.show()
            
            delegate?.linkNavRequested(request)
            
            return false
        }
        
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex == 0)
        {
            UIApplication.sharedApplication().openURL(self.linkRequest.URL)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.webView.hidden = false;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrolling a blog")
        
        var frame = self.headerView.frame
        var size = frame.size.height - 21
        var framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1))
        var scrollOffset = scrollView.contentOffset.y
        var scrollDiff = scrollOffset - self.previousScrollViewYOffset
        var scrollHeight = scrollView.frame.size.height
        var scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if(scrollOffset <= -scrollView.contentInset.top)
        {
            frame.origin.y = 20
        }
        else if((scrollOffset + scrollHeight) >= scrollContentSizeHeight)
        {
            frame.origin.y = -size
        }
        else
        {
            frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
        }
        
        self.headerView.frame = frame
        
        self.updateHeaderItems(1 - framePercentageHidden);

        self.previousScrollViewYOffset = scrollOffset
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if(!decelerate)
        {
            self.stoppedScrolling()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func stoppedScrolling(){
        var frame = self.headerView.frame
        
        if(frame.origin.y < 20)
        {
            self.animateHeader(-(frame.size.height - 21))
        }
    }
    
    func animateHeader(y:CGFloat)
    {
        UIView.animateWithDuration(0.2, animations: {
            var frame = self.headerView.frame
            var alpha:CGFloat = (frame.origin.y >= y ? 0 : 1) as CGFloat
            frame.origin.y = y
            self.headerView.frame = frame
            self.updateHeaderItems(alpha)
        })
    }
    
    func updateHeaderItems(alpha:CGFloat)
    {
        self.blogDateLabel.alpha = alpha
        self.blogTitleTextView.alpha = alpha
        self.blogAuthorLabel.alpha = alpha
        
        self.headerView.tintColor = self.headerView.tintColor.colorWithAlphaComponent(alpha)
    }
    func goBack()
    {
        println("Go back called")
        
        if(self.webView.canGoBack)
        {
            self.webView.goBack()
        }
    }
    
    
    func showABlog(selectedBlog:Blog)
    {
        
        //println("showing a blog")
        
        
        //var styleString = "<style type=\"text/css\">body{width:60%;margin-left:auto;margin-right:auto;}</style>"
        
        var styleString = "<style type=\"text/css\">p {font-size: 20px;}</style>"
        
        var htmlString:NSString = selectedBlog.postContent as NSString;
        
        htmlString = styleString.stringByAppendingString(htmlString)
        
        //println("showing a blog \(htmlString) ")

        
        self.webView.loadHTMLString(htmlString, baseURL: nil)
        
        self.webView.opaque = false
        self.webView.backgroundColor = UIColor(patternImage: UIImage(named: "sketch.png"))
        
        var blogColor = BlogColors.getColor(selectedBlog.blogId.stringValue)
        
        self.blogTitleTextView.backgroundColor = blogColor
        self.headerView.backgroundColor = blogColor
        
        self.blogTitleTextView.text = selectedBlog.blogTitle
        self.blogTitleTextView.textColor = UIColor.whiteColor()
        
        self.blogAuthorLabel.text = "By: ".stringByAppendingString(selectedBlog.author)
        self.blogAuthorLabel.textColor = UIColor.whiteColor()
        
        self.blogDateLabel.text = selectedBlog.postDate
        self.blogDateLabel.textColor = UIColor.whiteColor()
        
        
    }

}
