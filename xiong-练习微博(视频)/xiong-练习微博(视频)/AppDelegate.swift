//
//  AppDelegate.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
print("0.(AppDelegate)查看用户信息:",UserAccount.loadAccount())
        

        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = RootViewController()
        window?.rootViewController = WelcomeViewController()
        window?.makeKeyAndVisible()
        
        setupAppearance()
        
        return true
    }
    
    /// 设置外观
    func setupAppearance(){
        
        // 设置NavigationBar (顶部按钮)的外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        // 设置TabBar (底部按钮)的外观
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
}

