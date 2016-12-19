//
//  LOGoodsModel.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let DicKey_GoodsPic = "goodsPic"
let DicKey_GoodsTitle = "goodsTitle"
let DicKey_GoodsPrice = "goodsPrice"
let DicKey_GoodsFee = "goodsFee"
let DicKey_GoodsSalesNum = "goodsSalesNum"
let DicKey_GoodsAddr = "goodsAddr"



class LOGoodsModel: NSObject {

    var goodsPic: NSString! //图片
    var goodsTitle: NSString! //标题
    var goodsPrice: NSString! //价格
    var goodsFee: NSString! //运费
    var goodsSalesNum: NSString! //销售额
    var goodsAddr: NSString! //地址
    var goodsCount: NSString! //商品加入购物车个数
    
    
    class func initWithData(dataObj:NSDictionary) -> AnyObject {
        let goodsModel: LOGoodsModel = LOGoodsModel()
        if (dataObj .isKind(of: NSDictionary.self)) {
            let dic: NSDictionary = NSDictionary.init(dictionary: dataObj)
            
            goodsModel.goodsPic = dic["goodsPic"] as! NSString
            goodsModel.goodsTitle = dic["goodsTitle"] as! NSString
            goodsModel.goodsPrice = dic["goodsPrice"] as! NSString
            goodsModel.goodsFee = dic["goodsFee"] as! NSString
            goodsModel.goodsSalesNum = dic["goodsSalesNum"] as! NSString
            goodsModel.goodsAddr = dic["goodsAddr"] as! NSString
        }
        
        return goodsModel
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
