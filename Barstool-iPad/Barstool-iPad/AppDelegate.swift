//
//  AppDelegate.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/16/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        var settingsVC:SettingsTableViewController = storyboard.instantiateViewControllerWithIdentifier("settingsVC") as SettingsTableViewController

        let collectionVC = storyboard.instantiateViewControllerWithIdentifier("blogCollectVC") as BlogCollectionViewController;
        
        settingsVC.settingsDelegate = collectionVC
        
        var navVC = UINavigationController(rootViewController: collectionVC)

        
        var sideContainer = MFSideMenuContainerViewController.containerWithCenterViewController(navVC, leftMenuViewController: settingsVC, rightMenuViewController: nil)
        
        //self.window?.rootViewController = sideContainer
        //self.window?.makeKeyAndVisible()
        /*
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        [tabBarController setViewControllers:[NSArray arrayWithObjects:[self navigationController],
        [self navigationController], nil]];
        
        SideMenuViewController *leftSideMenuController = [[SideMenuViewController alloc] init];
        SideMenuViewController *rightSideMenuController = [[SideMenuViewController alloc] init];
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
        containerWithCenterViewController:tabBarController
        leftMenuViewController:leftSideMenuController
        rightMenuViewController:rightSideMenuController];
        
        self.window.rootViewController = container;
        [self.window makeKeyAndVisible];
*/
        
        
        BlogManager.sharedInstance.getBlogs()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

