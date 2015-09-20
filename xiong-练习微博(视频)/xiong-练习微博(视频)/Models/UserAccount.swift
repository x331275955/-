//
//  UserAccount.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/14.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    // MARK: - 成员属性:
    // 用于调用access_token，接口获取授权后的access token。
    var access_token : String?
    // 授权过期时间
    var expiresDate : NSDate?
    // 当前授权用户的UID。
    var uid : String?
    // 友好显示名称
    var name : String?
    // 用户的头像(大图180*180)
    var avatar_large : String?
    // access_token的生命周期，单位是秒数。
    var expires_in : NSTimeInterval = 0
    // 用户是否登录
    class var userLogon: Bool {
        return UserAccount.loadAccount() != nil
    }
    
    
    // MARK:- KVC字典转模型
    init(dict:[String:AnyObject]){
        // 调用父类的init方法
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        
        UserAccount.userAccount = self
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK:- 获取:对象描述信息.
    override var description: String {
        
        let properties = ["access_token","expires_in","uid","expiresDate", "name", "avatar_large"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    
    // 保存用户账号
    private func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    
    //MARK:- 加载用户信息
    func loadUserInfo(finished:(error: NSError?) -> ()){
        NetworkTools.sharedTools.loadUserInfo(uid!) { (result, error) -> () in

            if let dict = result{
                // 设置用户信息
                self.name = dict["name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                
// TODO: 保存用户信息
print("5.(UserAccount)保存用户信息",self.name,self.avatar_large)
                // 保存用户信息
                self.saveAccount()
            }
            finished(error: nil)
        }
    }
    
    // MARK:- 载入用户信息, 先判断账户是否为空,是否过期
    // 静态的用户账户属性
    private static var userAccount: UserAccount?
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
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true).last!.stringByAppendingString("/account.Plist")

    // 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    // 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
