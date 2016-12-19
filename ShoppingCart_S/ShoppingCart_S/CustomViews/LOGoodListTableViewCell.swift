//
//  LOGoodListTableViewCell.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOGoodListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddrs: UILabel!
    @IBOutlet weak var cntrnsHgtOfLblTitle: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let viewLine: UIView = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: ScreenWidth, height: 0.5))
        viewLine.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(viewLine)
    }
    
    func setCellViewsWithModel(model: LOGoodsModel) -> Void{
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        let hgt = model.goodsTitle.boundingRect(with: CGSize(width: ScreenWidth, height: 100), options: options, attributes: [NSFontAttributeName: lblTitle.font], context: nil).size.height + 2
        
        self.cntrnsHgtOfLblTitle.constant = hgt
        //使用sdwebimage
        self.imgViewPic.sd_setImage(with: URL.init(string: model.goodsPic as String))
        
        self.lblTitle.text = model.goodsTitle as String?
        self.lblPrice.text = "¥" + (model.goodsPrice as String?)!
        self.lblAddrs.text = model.goodsAddr as String?

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
