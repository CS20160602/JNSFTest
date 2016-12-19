//
//  LOGoodsDetailDB.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/15.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

let GOODSTABLE = "GoodsTable"

class LOGoodsDetailDB: NSObject {

    var _db: FMDatabase?
    
    override init() {
        _db = DBManage.sharedInstance._dataBase
    }
    
    //  创建数据表
    func createDataTable() -> Void {
        let set: FMResultSet = (_db?.executeQuery("select count(*) from sqlite_master where type ='table' and name = '\(GOODSTABLE)'", withArgumentsIn: nil))!
        
        set.next()
        
        let count = set.int(forColumnIndex: 0)
        
        if count != 0 {
            print("数据表已经存在")
        } else {
            let sql = "CREATE TABLE \(GOODSTABLE) (goodsPic text, goodsTitle text, goodsPrice text, goodsFee text, goodsSalesNum text, goodsAddr text, goodsCount text)"
            
            let isSuccess = (_db?.executeUpdate(sql, withArgumentsIn: nil))!
            
            if isSuccess {
                print("数据表创建成功")
            } else {
                print("数据表创建失败")
            }
            
        }
    }
    
    //保存数据模型
    func saveDetailModel(detailModel: LOGoodsModel) -> Void {
        let query = "INSERT INTO \(GOODSTABLE) (goodsPic,goodsTitle,goodsPrice,goodsFee,goodsSalesNum,goodsAddr,goodsCount) values (?,?,?,?,?,?,?)"
        
        var arguments = Array<Any>()
        
        if (detailModel.goodsPic != nil) {
            arguments.append(detailModel.goodsPic)
        }
        
        if (detailModel.goodsTitle != nil) {
            arguments.append(detailModel.goodsTitle)
        }
        
        if (detailModel.goodsPrice != nil) {
            arguments.append(detailModel.goodsPrice)
        }
        
        if (detailModel.goodsFee != nil) {
            arguments.append(detailModel.goodsFee)
        }
        
        if (detailModel.goodsSalesNum != nil) {
            arguments.append(detailModel.goodsSalesNum)
        }
        
        if (detailModel.goodsAddr != nil) {
            arguments.append(detailModel.goodsAddr)
        }
        
        if (detailModel.goodsCount != nil) {
            arguments.append(detailModel.goodsCount)
        }
        
        
        let isSuccess = _db?.executeUpdate(query, withArgumentsIn: arguments)
        
        if isSuccess! {
            print("存入成功")
        } else {
            print("存入失败")
        }
    }
    
    //根据title删除数据，实际开发中也可以使用id等唯一标示
    func deleteDetailWithTitle(detailTitle: String) -> Void {
        let query = "DELETE FROM \(GOODSTABLE) WHERE goodsTitle = '\(detailTitle)'"
        
        _db?.executeUpdate(query, withArgumentsIn: nil)
        
    }
    
    //更新数据
    func updateDetailModel(detailModel: LOGoodsModel) -> Void {
        let query = "update \(GOODSTABLE) set goodsCount=? where goodsTitle=?"
        
        var arguments = Array<Any>()
        
        if (detailModel.goodsCount != nil) {
            arguments.append(detailModel.goodsCount)
        }
        
        if (detailModel.goodsTitle != nil) {
            arguments.append(detailModel.goodsTitle)
        }
        
        let result = _db?.executeUpdate(query, withArgumentsIn: arguments)
        
        if !result! {
            print("创建失败")
        } else {
            print("创建成功")
        }
    }
    
    //查询表中所有数据，用于购物车列表的展示
    func selectAll() -> Array<Any>? {
        let query = "SELECT * FROM \(GOODSTABLE)"
        
        let result = _db?.executeQuery(query, withArgumentsIn: nil)
        
        var resultArray = Array<Any>()
        
        while (result?.next())! {
            let detailModel = LOGoodsModel()
            detailModel.goodsPic = result?.string(forColumn:"goodsPic") as NSString!
            detailModel.goodsTitle = result?.string(forColumn:"goodsTitle") as NSString!
            detailModel.goodsPrice = result?.string(forColumn:"goodsPrice") as NSString!
            detailModel.goodsFee = result?.string(forColumn:"goodsFee") as NSString!
            detailModel.goodsSalesNum = result?.string(forColumn:"goodsSalesNum") as NSString!
            detailModel.goodsAddr = result?.string(forColumn:"goodsAddr") as NSString!
            detailModel.goodsCount = result?.string(forColumn:"goodsCount") as NSString!
            
            resultArray.append(detailModel)
        }
        
        result?.close()
        
        return resultArray
    }
    
    
}
