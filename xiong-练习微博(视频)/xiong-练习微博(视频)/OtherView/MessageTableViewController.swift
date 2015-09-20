//
//  MessageTableViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/12.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitor?.setupViewInfo(false, imageName: "visitordiscover_image_message", message: "登录后别人评论你的微博,发给你的信息,都会在这里收到通知")
    }
}
