//
//  OAuthViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/13.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController,UIWebViewDelegate {

    // MARK:- 搭建界面:
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        
        title = "新浪微博"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
    // 关闭界面
    func close(){
        SVProgressHUD.dismiss() 
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 加载View
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: NetworkTools.sharedTools.oauthUrl()))
    }
    
    // MARK:- WebView代理方法 (一共4个,下面这3个都是)
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // 获取code
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取URL
        let urlString = request.URL!.absoluteString
        
        // 如果URL中 包含回调地址 就继续加载
        if !urlString.hasPrefix(NetworkTools.sharedTools.redirectUri){
            return true
        }
        
        // 获取URL中的request(就是参数,'?'后面的东西)  并且在request中是否包含 'code='
        if let query = request.URL?.query where query.hasPrefix("code=") {
            // 截取 code= 后面的字符串
            let str = NSString(string: query)
            let code = str.substringFromIndex("code=".characters.count)

// TODO: 拿到code
print("2.(OAuthView)拿到code=" + code)
            
            loadAccessToken(code)
            
        }else{
            close()
        }
        return false
    }
    
    // MARK:- 调用单例方法:
    private func loadAccessToken(code:String){
        NetworkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in
            
            // 有错误或者数据为空
            if error != nil || result == nil{
                // 显示网络不给力
                self.netError()
                return
            }
            
// TODO: 获取Token
print("3.(OAuthView)获取Token:",result)
            
            // 数据不为空,登录成功
            // 字典转模型
            UserAccount(dict: result!).loadUserInfo({(error) -> () in
                if error != nil{
                    print("错误!!")
                    self.netError()
                    return
                }
                self.netSucceed()
            })
        }
    }
    
    // 打印错误方法
    private func netError(){
        SVProgressHUD.showInfoWithStatus("您的网络不给力")
        
        // 延时一段时间再关闭
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue()) {
            self.close()
        }
    }
    
    // 打印成功方法
    private func netSucceed(){
        SVProgressHUD.showInfoWithStatus("登录成功")
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue(), { () -> Void in
            
            self.close()
        })
    }
}
