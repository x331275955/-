//
//  BaseTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController , VisitorViewDelegate{
    
    /// 记录用户是否登录属性
    var userLogin = UserAccount.loadAccount() != nil 
    
    /// 定义view
    var visitor : VisitorView?
    
    /// 改写loadView 使其判定用户是否登录
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
        
    }

    /// 设置访客视图
    private func setupVisitorView(){
        
        visitor = VisitorView()
        visitor?.delegate = self
        view = visitor
        
        // 设置BarButtonItem的文字和点击
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillLogin")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillRegister")
    }
    
    // MARK: - 代理方法
    func visitorViewWillLogin() {
        
        let nav = UINavigationController(rootViewController: OAuthViewController())
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func visitorViewWillRegister() {
        print("点击了注册按钮")
    }
}
