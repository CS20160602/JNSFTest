//
//  LOShoppingCartCell.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOShoppingCartCell: UITableViewCell {

    @IBOutlet weak var goodsImage: UIImageView!
    @IBOutlet weak var goodsTitle: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsCount: UILabel!
    
    var goodsModel:LOGoodsModel?
    var editView:LOEditView?
    
    //定义返回结果的函数
    typealias ResultRequestType = (Bool,LOGoodsModel) -> Void
    var resultRes:ResultRequestType?
    
    //初始化模型和返回结果函数
    func setDataWithModel(model: LOGoodsModel, andResultRequest resultRequest:@escaping ResultRequestType) -> Void {
        self.goodsModel = model;
        self.goodsTitle.text = model.goodsTitle as String?;
        self.goodsPrice.text = "¥" + (model.goodsPrice as String?)!
        self.goodsCount.text = model.goodsCount as String?;
        
        self.goodsImage.sd_setImage(with: URL.init(string: model.goodsPic as String))
        
        self.resultRes = resultRequest
        self.editBtn.setTitle("编辑", for: UIControlState.normal)
    }

    //编辑商品
    @IBAction func editButtonAction(_ sender: Any) {
        let editString: NSString = (self.editBtn.titleLabel?.text)! as NSString
        if editString.isEqual(to: "完成") {
            self.editBtn.setTitle("编辑", for: UIControlState.normal)
            self.editView?.removeFromSuperview()
            
            if (self.goodsModel?.goodsCount.isEqual(to: self.editView?.goodsCountString as! String))! {
                self.resultRes!(false,self.goodsModel!)
                return
            }
            self.goodsModel?.goodsCount = self.editView?.goodsCountString
            
            let db = LOGoodsDetailDB()
            db.createDataTable()
            db.updateDetailModel(detailModel: self.goodsModel!)
            
            self.resultRes!(true, self.goodsModel!)
        }else{
            self.editBtn.setTitle("完成", for: UIControlState.normal)
            self.initEditView()
        }
        
    }
    
    //创建编辑商品个数的view
    func initEditView() -> Void {
        let editView:LOEditView = Bundle.main.loadNibNamed("LOEditView", owner: self, options: nil)?.last as! LOEditView
        editView.setDataWithModel(model: self.goodsModel!)
        editView.frame = CGRect(x: 123, y: 26, width: self.contentView.frame.size.width - 120, height: 84)
        self.contentView.addSubview(editView)
        self.editView = editView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
