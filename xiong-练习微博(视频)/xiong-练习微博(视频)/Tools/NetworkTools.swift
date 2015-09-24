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

// 定义错误的枚举 (枚举是定义一组相关,类似的值)
// Swift 中 枚举可以定义函数和属性, 和'类'有些相似
private enum XNetworkError: Int {

    case emptyDataError = -1
    case emptyTokenError = -2
    
    // 错误描述
    private var errorDesrption: String {
        switch self {
        case.emptyDataError : return "空数据"
        case.emptyTokenError: return "Token为空"
        }
    }
    
    // 根据枚举类型,返回对应错误
    private func error() -> NSError {
        return NSError(domain: XErrorDomainName, code: rawValue, userInfo: [XErrorDomainName: errorDesrption])
    }
}

// 网络访问方法
private enum XNetworkMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager{
    
    // MARK:- 应用程序信息
    private let clientId = "3959022179"
    private let appSecret = "e2f4c5a876cc8b8139ae93832e43ab0f"
    // 回调地址
    let redirectUri = "http://www.baidu.com"
    
    // MARK:- 封装AFN 网络方法,便于替换网络访问方法,第三方框架的网络代码全部集中于此
    typealias XNetFinishedCallBack = ((result:[String:AnyObject]?, error:NSError? )->())
    
    // 单例
    static let sharedTools : NetworkTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        let tools = NetworkTools(baseURL: baseURL)
        
        // 增加AFN框架的支持格式
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain") as Set<NSObject>
        
        return tools
    }()
    
    // MARK:- 加载用户数据
    func loadUserInfo(uid:String, finished: XNetFinishedCallBack) {
        
        // 判断 token 是否存在
        if UserAccount.loadAccount()?.access_token == nil {
            
            let error = XNetworkError.emptyTokenError.error()
            print(error)
            // 错误回调,Token为空
            finished(result: nil, error: error)
            
            return
        }
        
        let urlString = "2/users/show.json"
        let params: [String:AnyObject]  = ["access_token":UserAccount.loadAccount()!.access_token! , "uid":uid]
        
        print("4.(NetworkTools)正在获取用户信息" + urlString)
        
        // 发送网络请求
        request(XNetworkMethod.GET, urlString: urlString, params: params, finished: finished)
    }
    
    // MARK:- OAuth授权
    func oauthUrl() -> NSURL {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        
        print("1.(NetworkTools)到授权URL中填写密码:" + urlString)
        
        return NSURL(string: urlString)!
    }
    
    // 加载Token
    func loadAccessToken(code:String, finished:(XNetFinishedCallBack)){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = [  "client_id":clientId,
                        "client_secret":appSecret,
                        "grant_type":"authorization_code",
                        "code":code,
                        "redirect_uri":redirectUri]
        
        // 发送POST请求 获取Token
        request(XNetworkMethod.POST, urlString: urlString, params: params, finished: finished)
    }
    
    
    private func request(method: XNetworkMethod, urlString: String, params: [String: AnyObject], finished: XNetFinishedCallBack){
        // 1. 定义成功闭包
        let successCallBack: (NSURLSessionDataTask!, AnyObject!) -> Void = { (_, JSON) -> Void in
            
            if let result = JSON as? [String:AnyObject]{
                // 有结果的回调
                finished(result: result, error: nil)
            }else{
                let er = XNetworkError.emptyTokenError.error()
                print(er)
                finished(result: nil, error: er)
            }
        }
        
        // 2. 定义失败闭包
        let failedCallBack: (NSURLSessionDataTask!, NSError!) -> Void = {
            
            (_, error) -> Void in

            print(error)
            finished(result: nil, error: error)
        }
    
        // 3. 根据 method 来选择执行的方法
        switch method{
            case.GET : GET(urlString, parameters: params, success: successCallBack, failure: failedCallBack)
            case.POST : POST(urlString, parameters: params, success: successCallBack, failure: failedCallBack)
        }
    }
}
