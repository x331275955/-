//
//  NetworkTools.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/13.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit
import AFNetworking

// 错误的大类别标记
private let XErrorDomainName = "com.xiong.error.network"

class NetworkTools: AFHTTPSessionManager{
    
    // 应用程序信息
    private let clientId = "3959022179"
    private let appSecret = "e2f4c5a876cc8b8139ae93832e43ab0f"
    // 回调地址
    let redirectUri = "http://www.baidu.com"
    
    // 单例
    static let sharedTools : NetworkTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        let tools = NetworkTools(baseURL: baseURL)
        
        // 增加AFN框架的支持格式
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain") as Set<NSObject>
        
        return tools
    }()
    
    // MARK:- 加载用户数据
    func loadUserInfo(uid:String, finished: XiongNetFinishedCallBack) {
        
        // 判断 token 是否存在
        if UserAccount.loadAccount()?.access_token == nil {
            return
        }
        
        let urlString = "2/users/show.json"
        let params: [String:AnyObject]  = ["access_token":UserAccount.loadAccount()!.access_token! , "uid":uid]
        
// TODO: 正在获取用户信息
print("4.(NetworkTools)正在获取用户信息" + urlString)
        // 发送网络请求
        requesGET(urlString, params: params,finished:finished)
    }
    
    // MARK:- OAuth授权
    func oauthUrl() -> NSURL {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        
// TODO: 打印URL
print("1.(NetworkTools)到授权URL中填写密码:" + urlString)
        
        return NSURL(string: urlString)!
    }
    
    // 加载Token
    func loadAccessToken(code:String, finished:(XiongNetFinishedCallBack)){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = [  "client_id":clientId,
                        "client_secret":appSecret,
                        "grant_type":"authorization_code",
                        "code":code,
                        "redirect_uri":redirectUri]
        
        // 发送POST请求 获取Token
        POST(urlString, parameters: params, success: { (_, JSON) -> Void in
            finished(result: JSON as? [String : AnyObject], error: nil)
            }){(_,error) ->Void in
                
                print(error)
                finished(result: nil, error: error)
        }
    }
    
    // MARK:- 封装AFN 网络方法,便于替换网络访问方法,第三方框架的网络代码全部集中于此
    typealias XiongNetFinishedCallBack = ((result:[String:AnyObject]?, error:NSError? )->())
    
    /// GET请求
    ///
    /// - parameter urlString: URL请求
    /// - parameter params   : 参数字典
    /// - parameter finished : 完成回调
    private func requesGET(urlString:String , params:[String:AnyObject], finished:(XiongNetFinishedCallBack)){
        
        GET(urlString, parameters: params, success: { (_, JSON) -> Void in
            
            if let result = JSON as? [String:AnyObject]{
                // 有结果的回调
                finished(result: result, error: nil)
            }else{
                // 没有错误,同时没有结果
                let error = NSError(domain: XErrorDomainName, code: -1, userInfo: ["errorMessage":"空数据"])
                
                print("没有数据")
                finished(result: nil, error: error)
            }
            
            }) { (_, error) -> Void in
                
                print(error)
                finished(result: nil, error: error)
        }
    }
}
