//
//  AppDelegate.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

// 切换控制器的通知
let XRootViewControllerSwitchNotification = "XRootViewControllerSwitchNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 注册通知 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchViewController:", name: XRootViewControllerSwitchNotification, object: nil)
        
        print("0.(AppDelegate)查看用户信息:",UserAccount.loadAccount())
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        setupAppearance()
        
        return true
    }
    
    // 注销通知  (程序被销毁才会执行,只是一个习惯,不写也不会出现问题)
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 通知触发的方法
    func switchViewController(n:NSNotification) {
        
        let mainVC = n.object as! Bool
        
        window?.rootViewController = mainVC ? RootViewController() : WelcomeViewController()
    }
    
    
    // 返回默认启动控制器
    private func defaultViewController() -> UIViewController{
        
        // 1. 判断用户是否登录,如果没有返回主控制器
        if !UserAccount.userLogon{
            return RootViewController()
        }
        
        // 2. 判断是否是新版本,如果是,返回新特性,否则返回欢迎界面
        return isNewUpdate() ? NewUserCollectionViewController() : WelcomeViewController()
    }
    
    // 检查是否是新版本
    private func isNewUpdate() -> Bool{
        // 1.检查当前版本
        let currentVersion = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
        
        // 2.获取之前的版本
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        
        // 3.保存当前版本
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion!, forKey: sandboxVersionKey)
        
        // 同步一下, iOS 7.0 之后就不需要同步了,但是写了也没事 iOS 6.0 之前不同步不会第一时间保存到沙盒的
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 4.返回版本比较
        return currentVersion > sandboxVersion
    }
    
    /// 设置外观
    func setupAppearance(){
        
        // 设置NavigationBar (顶部按钮)的外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        // 设置TabBar (底部按钮)的外观
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
}

