//
//  BlogCollectionViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/23/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

let reuseIdentifier = "blogCell"

class BlogCollectionViewController: UIViewController,BlogManagerDelegate, CHTCollectionViewDelegateWaterfallLayout, UISplitViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    var refreshView:UIRefreshControl
    var hideMenu:Bool
    
    @IBOutlet var collectionView: UICollectionView!
    required init(coder aDecoder: NSCoder) {
    
        refreshView = UIRefreshControl()
        hideMenu = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.hideMenu = true
        BlogManager.sharedInstance.delegate = self
        self.splitViewController?.delegate = self
                
        refreshView.addTarget(self, action: NSSelectorFromString("startRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView?.addSubview(refreshView)
        
        self.navigationController?.navigationBar
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("scrolling")
    }
    
    func startRefresh()
    {
        BlogManager.sharedInstance.getBlogs()
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
        
        self.collectionView?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSizeMake(200, 200)
        
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    



     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return BlogManager.sharedInstance.blogs.count
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as BlogCollectionViewCell
        
        
        
        cell.setupCell(BlogManager.sharedInstance.blogs.objectAtIndex(indexPath.row) as Blog)
        
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
        
        //vc.selectedBlog = BlogManager.sharedInstance.blogs.objectAtIndex(ip.row) as? Blog
        
        vc.blogIndex = ip.row
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
