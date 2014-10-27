//
//  SettingsTableViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/7/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate {
    
    func blogFilter(blogId:String)
}

class SettingsTableViewController: UITableViewController {

    
    let blogNames = ["Super Page", "Boston", "New York City", "Philly", "BarstoolU", "Chicago", "DMV", "Iowa"]
    
    var settingsDelegate:SettingsViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(section == 0)
        {
            return 0
        }
        else
        {
            return blogNames.count
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(indexPath.section == 0)
        {
                
        }
        else
        {
            settingsDelegate?.blogFilter(BlogColors.getBlogId(blogNames[indexPath.row]))
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell
        
        if(indexPath.section == 0)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("LoginCell") as UITableViewCell
            
            cell.textLabel?.text = "Login Info"
        }
        else
        {
            cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as UITableViewCell
            cell.textLabel?.text = blogNames[indexPath.row] as String
        }
        
        return cell
    }

}
