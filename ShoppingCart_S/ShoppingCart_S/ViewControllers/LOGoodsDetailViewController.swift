//
//  LOGoodsDetailViewController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

let Hgt_ImgView:CGFloat = 400
let Hgt_BtnFoot:CGFloat = 50

class LOGoodsDetailViewController: BaseViewController, UIScrollViewDelegate {

    var goodsModel:LOGoodsModel!
    var scrollView:UIScrollView!
    var imgView:UIImageView!
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.initBackButton(imgName: nil)
        self.initRightButtonWithImage(image: UIImage.init(named: "ShopCart")!)
        self.setCustomNaviViewBackgroundColor(bgColor: UIColor.brown.withAlphaComponent(0.0))
        
        self.initScrollView()
        self.initAddToShopCartFooterView()
        
    }

    //MARK: - UI
    
    func updateSubviewsOfTopViewAlpha(alpha: CGFloat) -> Void {
        self.topView?.backgroundColor = UIColor.brown.withAlphaComponent(alpha)
    }
    
    func initScrollView() -> Void {
        let scrollView: UIScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - Hgt_BtnFoot))
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        
        self.initImageView()
        self.initTitleHeaderView()
        self.view.bringSubview(toFront: self.topView!)
    }
    
    func initImageView() -> Void {
        
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: Hgt_ImgView))
        imgView.sd_setImage(with: URL.init(string: self.goodsModel.goodsPic as String))
        self.scrollView.addSubview(imgView)
        self.imgView = imgView
    }
    
    func initTitleHeaderView() -> Void {
        let detailTitle:LODetailTitleHeader = Bundle.main.loadNibNamed("LODetailTitleHeader", owner: self, options: nil)?.last as! LODetailTitleHeader
        detailTitle.setDataWithModel(model: self.goodsModel)
        
        detailTitle.frame = CGRect(x: 0, y: imgView.frame.size.height, width: self.view.frame.size.width, height: detailTitle.frame.size.height)
        let contentHgt = detailTitle.frame.origin.y + detailTitle.frame.size.height
        if contentHgt > self.scrollView.frame.size.height {
            self.scrollView.isScrollEnabled = true
        }
        self.scrollView.addSubview(detailTitle)
    }
    
    func initAddToShopCartFooterView() -> Void {
        let btnFooter:UIButton = UIButton.init(type: UIButtonType.custom)
        btnFooter.frame = CGRect(x: 0, y: self.view.frame.size.height - Hgt_BtnFoot, width: self.view.frame.size.width, height: Hgt_BtnFoot)
        btnFooter.backgroundColor = UIColor.orange
        btnFooter.setTitle("加入购物车", for: UIControlState.normal)
        btnFooter.setTitle("加入购物车", for: UIControlState.highlighted)
        btnFooter.addTarget(self, action: #selector(LOGoodsDetailViewController.clickGoodToShopCart), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnFooter)
    }
    
    func clickGoodToShopCart(sender:UIButton) -> Void {
        ToolUtility.createToastView(withContent: "加入购物车成功", withSuperView: self.view, andFrame: CGRect.zero)
        
        let db: LOGoodsDetailDB = LOGoodsDetailDB()
        db.createDataTable()
        
        //加入购物车时先获取购物车中已经存在的商品数量，如果商品存在就在商品个数基础上添加
        var array:[Any]? = db.selectAll()
        for i in 0..<(array?.count)! {
            let model = (array?[i] as! LOGoodsModel)
            let str = model.goodsTitle
            if (str?.isEqual(to: self.goodsModel.goodsTitle as String))! {
                let count = model.goodsCount.intValue + 1
                model.goodsCount = "\(count)" as NSString!
                db.updateDetailModel(detailModel: model)
                return
            }
        }
        goodsModel.goodsCount = "1"
        db.saveDetailModel(detailModel: goodsModel)
        
    }
    
    override func clickRightButton(btn: UIButton) {
        let cartVC: LOShoppingCartController = LOShoppingCartController()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var topViewAlpha:CGFloat = 0
        topViewAlpha = scrollView.contentOffset.y / CGFloat(TITLE_AND_STATUS_BAR_HEIGHT);
        self.updateSubviewsOfTopViewAlpha(alpha: topViewAlpha)

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
