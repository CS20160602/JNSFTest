//
//  LODetailTitleHeader.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LODetailTitleHeader: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFeePrice: UILabel!
    @IBOutlet weak var lblSalesNum: UILabel!
    @IBOutlet weak var lblAddr: UILabel!

    @IBOutlet weak var cntrnsHgtOfLblTitle: NSLayoutConstraint!
    
    func setDataWithModel(model: LOGoodsModel) -> Void {
        var height = self.frame.size.height
        
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        let hgt = model.goodsTitle.boundingRect(with: CGSize(width: ScreenWidth, height: 100), options: options, attributes: [NSFontAttributeName: lblTitle.font], context: nil).size.height + 2
        
        self.cntrnsHgtOfLblTitle.constant = hgt
        
        self.lblTitle.text = model.goodsTitle as String?;
        self.lblPrice.text =  "¥" + (model.goodsPrice as String?)!
        if (model.goodsFee.integerValue > 0) {
            self.lblFeePrice.text =  "快递：" + (model.goodsFee as String?)! + "元路费"
        }else{
            self.lblFeePrice.text = "快递：免运费"
        }
        
        self.lblSalesNum.text = "月销" + (model.goodsSalesNum as String?)! + "笔"
        self.lblAddr.text = model.goodsAddr as String?;
        
        if (hgt > 21) {
            height += hgt - 21;
        }
        
        self.frame.size.height = height;
        
    }
    
    

}
