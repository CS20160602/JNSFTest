//
//  LOEditView.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOEditView: UIView {

    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var goodsModel:LOGoodsModel?
    var goodsCountString:NSString?
    
    func setDataWithModel(model:LOGoodsModel) -> Void {
        self.countLabel.text = model.goodsCount as String?
        self.goodsCountString = model.goodsCount
        self.goodsModel = model;
    }
    
    @IBAction func subAction(_ sender: Any) {
        let count:Int = Int(self.countLabel.text!)!
        if count <= 1 {
            
            NotificationCenter.default.post(name: ("不能再少了哦~" as NSString) as NSNotification.Name, object: "不能再少了哦~")
            return
        }
        self.countLabel.text = "\(count - 1)"
        self.goodsCountString = self.countLabel.text as NSString?
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        let count:Int = Int(self.countLabel.text!)!
        self.countLabel.text = "\(count + 1)"
        self.goodsCountString = self.countLabel.text as NSString?
        
        if count > 1 {
            self.subButton.isUserInteractionEnabled = true;
            self.subButton.alpha = 1.0
        }
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        let title: NSString = (self.goodsModel?.goodsTitle)!
        NotificationCenter.default.post(name: ("删除商品" as NSString) as NSNotification.Name, object: title)
        self.removeFromSuperview()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
