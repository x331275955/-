//
//  HomeTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitor?.setupViewInfo(true, imageName: "visitordiscover_feed_image_smallicon", message: "关注一些人,回这里看看有什么惊喜")
    }
}
