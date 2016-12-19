//
//  SView.swift
//  day21_lesson1
//
//  Created by 杨少锋 on 16/12/14.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

import UIKit

protocol SViewDelegate {
    func selectImageView(indexPath:IndexPath,sView:SView)
}

class SView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    var localImageArr : [String]? = nil
    var timer : Timer? = nil
    var collection : UICollectionView? = nil
    var delegate : SViewDelegate? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.size.width, height: frame.size.height)
        let collectV = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: layout)
        collectV.delegate = self
        collectV.dataSource = self
        collectV.showsVerticalScrollIndicator = false//横向滚动条
        collectV.isPagingEnabled = true//整页翻动
        collectV.bounces = false//触壁反弹
        collectV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "tag")
        self.addSubview(collectV)
        self.collection = collectV
        //定时器
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
        self.timer?.fire()//启动timer
        
        //添加pagecontril，
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //轮播图的宽度
    //轮播图的位置
    //图片的数组
    class func creatSView(frame:CGRect,imageArr:[String]) -> SView {
        let sview = SView(frame: frame)
        sview.localImageArr = imageArr
        sview.localImageArr?.append((sview.localImageArr?[0])!)
        return sview
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.localImageArr?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tag", for: indexPath)
        //给cell添加图片
        for view in subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
        //添加
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.frame.size.height))
            imageView.image = UIImage(named: (self.localImageArr?[indexPath.row])!)
        cell.addSubview(imageView)
        return cell
    }
    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //如果contentOffset >= 4
        let width = scrollView.contentSize.width - self.frame.size.width
        //let collectionV = scrollView as! UICollectionView
        if scrollView.contentOffset.x >= width {
            //let indexPath = IndexPath(row: 0, section: 0)
            //collectionV.scrollToItem(at: indexPath, at: .top, animated: false)
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    var isFirstOpen = true//是不是第一次启动定时器
    func timerAction(){
        if isFirstOpen {
            isFirstOpen = !isFirstOpen
            return
        }
        //让当前的scrollView执行
        let point = CGPoint(x: (self.collection?.contentOffset.x)! + self.frame.size.width, y: (self.collection?.contentOffset.y)!)
        self.collection?.setContentOffset(point, animated: true)
    }
    //开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //暂停定时器
        self.timer?.invalidate()
        //把定时器自控
        self.timer = nil
    }
    //结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
            self.timer?.fire()
        }
    }
    //collectionView的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = delegate {
            //如果等于最后一个
            var indexP : IndexPath? = nil
            if indexPath.row == (self.localImageArr?.count)! - 1 {
                indexP = IndexPath(row: 0, section: 0)
            }
            indexP = indexPath
            self.delegate?.selectImageView(indexPath: indexPath, sView: self)
        }
    }
}








