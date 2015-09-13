//
//  DiscoverTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitor?.setupViewInfo(false, imageName: "visitordiscover_image_message", message: "登录后,最新,最热,微博尽在掌握,不再与事实潮流擦肩而过")
    }
}
