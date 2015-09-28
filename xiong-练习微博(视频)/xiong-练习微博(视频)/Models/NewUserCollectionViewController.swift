//
//  NewUserCollectionViewController.swift
//  xiong-练习微博(视频)
//
//  Created by 王晨阳 on 15/9/20.
//  Copyright © 2015年 IOS. All rights reserved.
//

import UIKit

private let imageCount = 4

private let reuseIdentifier = "Cell"

class NewUserCollectionViewController: UICollectionViewController {
    
    // 手动弄一个layout
    private let layout = XCollectionFlowLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        // 调用super是为了 用sb开发
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用自定义Cell
        self.collectionView!.registerClass(NewUserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK:- 数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewUserCell
        
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 获取当前显示的 indexPath
        let path = collectionView.indexPathsForVisibleItems().last!
        
        // 判断是否是末尾的 indexPath
        if path.item == imageCount - 1 {
        
            // 播放动画
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewUserCell
            
            cell.startButtonAnim()
        }
    }
}

// 新特性的cell
class NewUserCell: UICollectionViewCell {
    
    // 点击StartButton事件
    func clickStartButton(){
        
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(XRootViewControllerSwitchNotification, object: true)
    }
    
    
    // 图像索引 -- 私有属性在同一个文件里是可以访问的.
    private var imageIndex: Int = 0{
        didSet{
            
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            
            startButton.hidden = true
        }
    }
    
    // 设置startButton的动画
    private func startButtonAnim(){
        
        startButton.hidden = false
        
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 恢复默认形变
            self.startButton.transform = CGAffineTransformIdentity
            
            }) { (_) -> Void in
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareUI()
    }
    
    private func prepareUI(){
       
        // 添加控件 -- 建议都加载到 contentView 上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 自动布局
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView": iconView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView": iconView]))
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -160))
        
    }
    
    // MARK: - 懒加载控件
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        button.addTarget(self, action: "clickStartButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 根据背景图片自动调整大小
        button.sizeToFit()
        
        return button
    }()
}

// 顺序:1.数据源获取cell数量.   2.获取layout     3. 数据源方法   去布局cell
// 自定义流水布局
private class XCollectionFlowLayout: UICollectionViewFlowLayout{
    
    // 设置各种属性!!!!
    private override func prepareLayout() {
        // 设置图片大小
        itemSize = collectionView!.bounds.size
        // 设置间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置分页
        collectionView?.pagingEnabled = true
        // 设置滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        // 设置弹性
        collectionView?.bounces = false
    }
}
