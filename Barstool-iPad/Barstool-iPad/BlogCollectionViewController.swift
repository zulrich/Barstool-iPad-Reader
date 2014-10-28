//
//  BlogCollectionViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/23/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit
import iAd

let reuseIdentifier = "blogCell"

class BlogCollectionViewController: UIViewController,BlogManagerDelegate, CHTCollectionViewDelegateWaterfallLayout, UISplitViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate, SettingsViewDelegate
{
    var refreshView:UIRefreshControl
    var hideMenu:Bool
    var adBanner:ADBannerView!
    var bannerIsVisible:Bool
    var blogIndex:String
    
    
    @IBOutlet var collectionView: UICollectionView!
    required init(coder aDecoder: NSCoder) {
    
        refreshView = UIRefreshControl()
        hideMenu = true
        bannerIsVisible = false
        self.blogIndex = "100"
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.hideMenu = true
        self.bannerIsVisible = false
        
        BlogManager.sharedInstance.delegate = self
        self.splitViewController?.delegate = self
                
        refreshView.addTarget(self, action: NSSelectorFromString("startRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView?.addSubview(refreshView)
        
        self.navigationController?.navigationBar
        
        self.blogIndex = "100"
        
        adBanner = ADBannerView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 66));
        adBanner.backgroundColor = UIColor.greenColor()
        
        //adBanner.delegate = self
        
        self.view.addSubview(adBanner)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("scrolling")
    }
    
    func startRefresh()
    {
        BlogManager.sharedInstance.getBlogs()
       //BlogManager.sharedInstance.getBlogsForId(blogIndex)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //BlogManager.sharedInstance.getBlogs()
    }
    
    func blogsDone() {
        
        if(refreshView.refreshing)
        {
            refreshView.endRefreshing()
        }
        
        println("Blogs done")
        
        self.blogFilter(blogIndex)
        
        self.collectionView?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSizeMake(200, 200)
        
    }
    
    func blogFilter(blogId: String) {
        
        BlogManager.sharedInstance.getBlogsForId(blogId)
        self.collectionView.reloadData()
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    



     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section

        return BlogManager.sharedInstance.blogsToShow.count
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as BlogCollectionViewCell
        
        
        
        cell.setupCell(BlogManager.sharedInstance.blogsToShow.objectAtIndex(indexPath.row) as Blog)
        
        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("viewBlogSegue", sender: indexPath)
    }
    
    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        
        return self.hideMenu
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var vc:ViewController = segue.destinationViewController as ViewController
        
        var ip = sender as NSIndexPath
                
        vc.blogIndex = ip.row
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        if(!self.bannerIsVisible)
        {
            UIView.animateWithDuration(0.25, animations: {
                
                //banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                //self.collectionView.frame = CGRectOffset(self.collectionView.frame, 0, -banner.frame.size.height)
                
//                self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y, self.collectionView.frame.width, self.collectionView.frame.size.height - banner.frame.size.height)
                
            })
            
            self.bannerIsVisible = true
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        
        let transitionToWide = size.width > size.height
        
        if(transitionToWide)
        {
            //banner.frame = CGRectOffset(banner.fram, <#dx: CGFloat#>, <#dy: CGFloat#>)
            
            if(bannerIsVisible)
            {
                adBanner.frame = CGRectMake(0, size.height - adBanner.frame.height, 1024, adBanner.frame.height)
                self.collectionView.frame = CGRectOffset(self.collectionView.frame, 0, -adBanner.frame.height)
                
            }
            
        }
        else
        {
            if(bannerIsVisible)
            {
                adBanner.frame = CGRectMake(0, size.height - adBanner.frame.height, 768, adBanner.frame.height)
                self.collectionView.frame = CGRectOffset(self.collectionView.frame, 0, -adBanner.frame.height)
            }
        }
        
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        println("Failed to load ad \(error)")
        
        if(self.bannerIsVisible)
        {
            UIView.animateWithDuration(0.25, animations: {
                //banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
                //self.collectionView.frame = CGRectOffset(self.collectionView.frame, 0, banner.frame.size.height)
            })
            self.bannerIsVisible = false
        }
        
    }

    @IBAction func settingsPressed(sender: AnyObject) {
        
    
//        if(self.hideMenu == true)
//        {
//            self.hideMenu = false
//            var controllers:NSArray? = self.splitViewController?.viewControllers as NSArray?
//            
//            var rootController: AnyObject? = controllers?.objectAtIndex(0)
//            
//            var rootView:UIView! = rootController?.view
//            var rootFrame = rootView.frame
//            
//            rootFrame.origin.x += rootFrame.size.width
//            
//            UIView.beginAnimations("showview", context: nil)
//            rootView.frame = rootFrame
//            UIView.commitAnimations()
//            
//        }
        
    
    }
}
