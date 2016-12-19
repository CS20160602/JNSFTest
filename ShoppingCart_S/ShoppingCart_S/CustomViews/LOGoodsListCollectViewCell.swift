//
//  LOGoodsListCollectViewCell.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

var GoodsListCollectViewCellId = "GoodsListCellId"
var Bottom_ImgPic:CGFloat = 75.0

class LOGoodsListCollectViewCell: UICollectionViewCell {

    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddrs: UILabel!
    
    func setCellViewsWithModel(model: LOGoodsModel) -> Void {
        self.imgViewPic.sd_setImage(with: URL.init(string: model.goodsPic as String))
        
        self.lblTitle.text = model.goodsTitle as String?;
        self.lblPrice.text = "¥" + (model.goodsPrice as String?)!
        self.lblAddrs.text = model.goodsAddr as String?
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
