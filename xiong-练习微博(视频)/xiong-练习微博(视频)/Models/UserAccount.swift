//
//  UserAccount.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/14.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    // 用于调用access_token，接口获取授权后的access token。
    var access_token : String?
    
    // access_token的生命周期，单位是秒数。
    var expires_in : NSTimeInterval = 0{
        didSet{
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 授权过期时间
    var expiresDate : NSDate?
    
    // 当前授权用户的UID。
    var uid : String?
    
    // 友好显示名称
    var name : String?
    // 用户的头像(大图180*180)
    var avatar_large : String?
    
    // KVC字典转模型
    init(dict:[String:AnyObject]){
        // 调用父类的init方法
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // 当找不到'键'时的处理  (空:为不处理,否则崩溃!!!)
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK:-重写description 方法,获取对象描述信息的明文
    override var description: String {
        
        let properties = ["access_token","expires_in","uid","expiresDate", "name", "avatar_large"]
        // 模型转字典
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    
    // 静态的用户账户属性
    private static var userAccount: UserAccount?
    
    // 保存用户账号
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    
    // MARK:-加载用户信息, 先判断账户是否为空,是否过期
    class func loadAccount() -> UserAccount? {
        
        // 如果账户为空从本地加载
        if userAccount == nil{
            
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
        }
        
        // 判断是否过期
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            
            // 如果过期,设置为空
            userAccount = nil
        }
        return userAccount
    }
    
    // MARK:- 归档和解档的方法
    /// 保存归档文件的路径
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/account.Plist")
    
    // MARK:- 归档 & 解档
    // 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    // 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
}
