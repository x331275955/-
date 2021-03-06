//
//  AppDelegate.swift
//  学习微博
//
//  Created by 王晨阳 on 15/9/9.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func setupAppearance() {
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor() 
        
    }
    
}

