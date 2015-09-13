//
//  visitorView.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class visitorView: UIView {

    /// 设置视图信息
    ///
    /// - parameter isHome   : 是否是主页
    /// - parameter imageName: 中央显示的图片
    /// - parameter message  : 要显示的信息
    func setupViewInfo(isHome: Bool, imageName: String, message: String){
        textLabel.text = message
        iconImageView.image = UIImage(named: imageName)
        
        houseImageView.hidden = !isHome
        
        isHome ? startAnimation() : sendSubviewToBack(backImageView)
    }
    
    private func startAnimation(){
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 10.0
        
        // 保证动画不会被切换的时候丢失
        anim.removedOnCompletion = false
        
        iconImageView.layer.addAnimation(anim, forKey: nil)
    }
    
    // 纯代码开发的时候会进入到这个方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 调用方法设置UI
        setupUI()
    }

    // XIB 和 SB 的时候会进入这个方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 调用方法 设置UI
        setupUI()
    }
    
    // 设置访客视图的UI界面
    private func setupUI(){
        // 1.添加子控件
        addSubview(iconImageView)
        addSubview(backImageView)
        addSubview(houseImageView)
        addSubview(textLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 设置背景颜色
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
        
        // 2.设置子控件的约束
        // 圆圈背景的约束
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -40))
        
        // 设置遮罩的约束
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: backImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // 设置小房子的约束
        houseImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: houseImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // 设置文字Label的约束
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
        // 设置注册按钮的约束
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        // 设置登录按钮的约束
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
    }
    
    // 注册按钮的点击事件
    func clickRegisterButton(){
        print("点击了注册按钮")
    }
    
    //  登录按钮的点击事件
    func clickLoginButton(){
        print("点击了登录按钮")
    }
    
    // MARK: -     懒加载各种控件
    // 背景圆圈
    lazy var iconImageView:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
    }()
    
    // 半透明遮罩
    lazy var backImageView:UIImageView = {
        let backImage = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return backImage
    }()
    
    // 小房子
    lazy var houseImageView:UIImageView = {
        let houseView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return houseView
    }()
    
    // 文字Label
    lazy var textLabel:UILabel = {
        let textLabel = UILabel()
        textLabel.text = "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜!"
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textColor = UIColor.darkGrayColor()
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // 注册按钮
    lazy var registerButton :UIButton = {
        let register = UIButton()
        
        register.setTitle("注册", forState: UIControlState.Normal)
        register.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        register.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        register.addTarget(self, action: "clickRegisterButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return register
    }()
    
    // 登录按钮
    lazy var loginButton :UIButton = {
        let login = UIButton()
        
        login.setTitle("登录", forState: UIControlState.Normal)
        login.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        login.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        login.addTarget(self, action: "clickLoginButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return login
    }()
}
