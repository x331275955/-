//
//  WelcomeViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/15.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // 动画所需约束
    private var iconBottomCons : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
        
        // 加载头像
        if let urlString = UserAccount.loadAccount()?.avatar_large {
            // 图像更新,会自动更新imageView的大小
            iconImageView.sd_setImageWithURL(NSURL(string: urlString))
        }
    }
    
    // 添加头像动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 提示:修改约束不会立即生效的,在这里添加一个标记,一会由咱们自己强制刷新UI
        iconBottomCons?.constant = -(UIScreen.mainScreen().bounds.height + iconBottomCons!.constant)
        
        // 设置动画
        UIView.animateWithDuration(1.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
                // 强制刷新约束
                self.view.layoutIfNeeded()
            
            }){ (_) -> Void in
                
        }
    }
    
    //MARK:- 添加控件--并设置控件约束
    private func prepareUI(){
        view.addSubview(backImageView)
        view.addSubview(iconImageView)
        view.addSubview(label)
    
        // 背景约束(等于屏幕大小)
        backImageView.frame = UIScreen.mainScreen().bounds
        // 头像约束(相对View,CenterX对齐,底部相对差150)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -150))
        // 记录底边约束
        iconBottomCons = view.constraints.last
        
        // 文字约束(相对iconImageView, CenterX对齐,文字在头像下方10)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
    }
    
    // MARK:- 懒加载控件
    // 背景图片
    private lazy var backImageView : UIImageView = UIImageView(image: UIImage(named: "ad_background"))

    // 用户头像
    private lazy var iconImageView : UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 45

        return iv
    }()
    // 消息文字
    private lazy var label : UILabel = {
        let label = UILabel()
        label.text = "欢迎归来"
        label.sizeToFit()
        
        return label
    }()
}
