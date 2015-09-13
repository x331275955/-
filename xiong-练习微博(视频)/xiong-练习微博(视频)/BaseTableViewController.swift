//
//  BaseTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    /// 记录用户是否登录属性
    var userLogin = false
    
    /// 定义view
    var visitor : visitorView?
    
    /// 改写loadView 使其判定用户是否登录
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }

    /// 设置访客视图
    private func setupVisitorView(){
        
        visitor = visitorView()
        view = visitor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: "clickRegisterButton", action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: "clickLoginButton", action: nil)
    }
    
    
    
}
