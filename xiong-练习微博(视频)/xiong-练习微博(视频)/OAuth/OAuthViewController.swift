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

    // MARK:搭建界面
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        
        title = "新浪微博"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
    // 关闭方法
    func close(){
        SVProgressHUD.dismiss() 
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 加载View
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        webView.loadRequest(NSURLRequest(URL: NetworkTools.sharedTools.oauthUrl()))
    }
    
    // MARK:- WebView代理方法
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
            
            //TODO: 获取 TOKEN
            loadAccessToken(code)
        }else{
            close()
        }
        return false
    }
    
    // 调用单例方法
    private func loadAccessToken(code:String){
        NetworkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in
            if error != nil || result == nil{
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                
                let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                dispatch_after(when, dispatch_get_main_queue(), { () -> Void in
                    self.close()
                })
                return
            }else if result != nil {
                SVProgressHUD.showInfoWithStatus("登录成功")
                
                let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                dispatch_after(when, dispatch_get_main_queue(), { () -> Void in
                    self.close()
                })
                
                // 字典转模型
                let account = UserAccount(dict: result!)
                account.saveAccount()
                NetworkTools.sharedTools.loadUserInfo(account.uid!, finished: { (result, error) -> () in
                })
                return
            }
        }
    }
}
