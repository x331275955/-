//
//  UserAccount.swift
//  我的微博
//
//  Created by 刘凡 on 15/7/29.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 用户账户类
class UserAccount: NSObject, NSCoding {
    
    /// 全局账户信息
    private static var sharedAccount: UserAccount?
    class func sharedUserAccount() -> UserAccount? {
        if sharedAccount == nil {
            sharedAccount = UserAccount.loadAccount()
        }
        
        if let date = sharedAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            sharedAccount = nil
        }

        return sharedAccount
    }
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: NSTimeInterval = 0
    /// 过期日期
    var expiresDate: NSDate?
    /// 当前授权用户的UID
    var uid: String?

    private init(dict: [String: AnyObject]) {
        super.init()
        
        self.setValuesForKeysWithDictionary(dict)
        expiresDate = NSDate(timeIntervalSinceNow: expires_in)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let dict = ["access_token", "expires_in", "uid", "expiresDate"]
        
        return "\(dictionaryWithValuesForKeys(dict))"
    }
    
    // MARK: - 归档 & 解档
    /// 归档保存路径
    private static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingPathComponent("useraccount.plist")
    
    /// 保存账户信息
    class func saveAccount(dict: [String: AnyObject]) {
        sharedAccount = UserAccount(dict: dict)
        NSKeyedArchiver.archiveRootObject(sharedAccount!, toFile: accountPath)
    }
    
    /// 加载账户信息
    private class func loadAccount() -> UserAccount? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
    }

    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
}
