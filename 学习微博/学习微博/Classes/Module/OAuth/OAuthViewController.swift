//
//  OAuthViewController.swift
//  我的微博
//
//  Created by 刘凡 on 15/7/29.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController, UIWebViewDelegate {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
    /// 关闭
    func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        webView.loadRequest(NSURLRequest(URL: NetworkTools.sharedNetworkTools.oauthURL))
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // 判断请求的 URL 中是否包含回调地址
        let urlString = request.URL!.absoluteString
        if !urlString.hasPrefix(NetworkTools.sharedNetworkTools.redirectUri) {
            return true
        }
        
        guard let query = request.URL?.query where query.hasPrefix("code=") else {
            print("取消授权")
            close()
            
            return false
        }
        
        let code = query.substringFromIndex(advance(query.startIndex, "code=".characters.count))
        print(code)
        loadAccessToken(code)
        
        return false
    }
    
    private func loadAccessToken(code: String) {
        NetworkTools.sharedNetworkTools.loadAccessToken(code) { (result, error) -> () in
            if error != nil || result == nil {
                SVProgressHUD.showInfoWithStatus("网络不给力")
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
                    self.close()
                }
                return
            }
            
            UserAccount.saveAccount(result!)
            print(UserAccount.sharedUserAccount())
        }
    }
}
