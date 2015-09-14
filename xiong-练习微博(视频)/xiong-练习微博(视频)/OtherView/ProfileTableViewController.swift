//
//  ProfileTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitor?.setupViewInfo(false, imageName: "visitordiscover_image_profile", message: "登录后,你的微博,相册,个人资料会显示在这里,展示给别人")
    }
}
