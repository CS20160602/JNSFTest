//
//  LOGoodListCollectionViewController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOGoodListCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var mutArrData: [LOGoodsModel] = []
    var itemSize:CGSize?
    var itemsCount:NSInteger?
    
    //商品列表
    var collectionView:UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsCount = self.mutArrData.count
        self.initCollectionView()
    }
    
    func initCollectionView() -> Void {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        let width = (ScreenWidth - 10.0) / 2
        let height = ((ScreenWidth - 10.0) / 2) + Bottom_ImgPic
        itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        
        let collectionRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let collectView:UICollectionView = UICollectionView.init(frame: collectionRect, collectionViewLayout: layout)
        collectView.dataSource = self
        collectView.delegate = self
        collectView.backgroundColor = UIColor.white
        self.view.addSubview(collectView)
        self.collectionView = collectView
        
        self.collectionView?.register(UINib.init(nibName: "LOGoodsListCollectViewCell", bundle: nil), forCellWithReuseIdentifier: GoodsListCollectViewCellId)
        self.configureCollectionView()
    }
    
    func configureCollectionView() -> Void {
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false;
        
        let width: NSLayoutConstraint = NSLayoutConstraint.init(item: self.collectionView!,
                                                                attribute: NSLayoutAttribute.width,
                                                                relatedBy: NSLayoutRelation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutAttribute.width,
                                                                multiplier: 1.0,
                                                                constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint.init(item: self.collectionView!,
                                                                 attribute: NSLayoutAttribute.height,
                                                                 relatedBy: NSLayoutRelation.equal,
                                                                 toItem: self.view,
                                                                 attribute: NSLayoutAttribute.height,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
        let top: NSLayoutConstraint = NSLayoutConstraint.init(item: self.collectionView!,
                                                              attribute: NSLayoutAttribute.top,
                                                              relatedBy: NSLayoutRelation.equal,
                                                              toItem: self.view,
                                                              attribute: NSLayoutAttribute.top,
                                                              multiplier: 1.0,
                                                              constant: 0)
        let leading: NSLayoutConstraint = NSLayoutConstraint.init(item: self.collectionView!,
                                                                  attribute: NSLayoutAttribute.leading,
                                                                  relatedBy: NSLayoutRelation.equal,
                                                                  toItem: self.view,
                                                                  attribute: NSLayoutAttribute.leading,
                                                                  multiplier: 1.0,
                                                                  constant: 0)
        self.view.addConstraints([width,height,top,leading])
    }
    
    func reloadGoodsCollectionView() -> Void{
        self.collectionView?.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectCell:LOGoodsListCollectViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsListCollectViewCellId, for: indexPath) as! LOGoodsListCollectViewCell
        if (mutArrData.count - 1) < indexPath.row {
            return collectCell
        }
        
        let model:LOGoodsModel = self.mutArrData[indexPath.row]
        collectCell.setCellViewsWithModel(model: model)
        
        return collectCell
    }
    
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (mutArrData.count - 1) < indexPath.row {
            return
        }
        
        let model:LOGoodsModel = self.mutArrData[indexPath.row]
        let goodDetailVC:LOGoodsDetailViewController = LOGoodsDetailViewController()
        goodDetailVC.goodsModel = model
        AppDelegate.gaNavigationController().pushViewController(goodDetailVC, animated: true)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
