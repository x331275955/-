//
//  RootViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 调用方法:加载所有子控制器
        lodingChildViews()

    }
    
    /// 视图即将出现的时候添加 tabBarButton 这样才会添加到最上层的图层上
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    /// 调用方法:添加tabBarButton
        addtabBarButton()
    }
    
    /// 加载所有的控制器
    private func lodingChildViews(){
        lodingChildView(HomeTableViewController(),title:"首页",ImageName:"tabbar_home")
        lodingChildView(MessageTableViewController(),title:"消息",ImageName:"tabbar_message_center")
        addChildViewController(UIViewController())
        lodingChildView(DiscoverTableViewController(),title:"发现",ImageName:"tabbar_discover")
        lodingChildView(ProfileTableViewController(),title:"我的",ImageName:"tabbar_profile")
    }
    
    /// 设置自控制器的属性
    ///
    /// - parameter vc       : 子控制器
    /// - parameter title    : 自控制器的title
    /// - parameter ImageName: 自控制器的tabbarItem
    private func lodingChildView(vc:UIViewController , title:String , ImageName:String ){
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: ImageName)
        
        let nv = UINavigationController(rootViewController: vc)
        
        addChildViewController(nv)
    }

    /// 添加按钮 设置按钮属性
    private func addtabBarButton(){
        let w = tabBar.bounds.width / CGFloat(viewControllers!.count)
        
        let rect = CGRect(x: 0, y: 0, width: w, height: self.tabBar.bounds.height)
        
        tabBarButton.frame = CGRectOffset(rect, 2 * w, 0)
        
    }
    
    /// tabBarButton 的点击事件
    func clicktabBarButton(){
        
        print("tabBarButton被点击了!")
    }
    
    /// 懒加载tabBarButton  并设置属性
    lazy private var tabBarButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        button.addTarget(self, action: "clicktabBarButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tabBar.addSubview(button)
        
        return button
    }()
    
    
}
