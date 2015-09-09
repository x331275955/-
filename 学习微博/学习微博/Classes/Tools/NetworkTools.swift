//
//  NetworkTools.swift
//  我的微博
//
//  Created by 刘凡 on 15/7/29.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import AFNetworking

/// 网络工具类
class NetworkTools: AFHTTPSessionManager {

    // 全局访问点
    static let sharedNetworkTools: NetworkTools = {
        let instance = NetworkTools(baseURL: NSURL(string: "https://api.weibo.com/")!)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        
        return instance
    }()
    
    // MARK: - OAuth 授权相关信息
    private var clientId = "113773579"
    private var clientSecret = "a34f52ecaad5571bfed41e6df78299f6"
    var redirectUri = "http://www.baidu.com"

    /// 授权 URL
    var oauthURL: NSURL {
        return NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)")!
    }
    
    /// 使用 code 获取 accessToken
    ///
    /// - parameter code: 请求码
    func loadAccessToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parames = ["client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectUri]
        
        POST(urlString, parameters: parames, success: { (_, JSON) in
            finished(result: JSON as? [String: AnyObject], error: nil)
            }) { (_, error) in
                finished(result: nil, error: error)
        }
    }
}
