//
//  DBManage.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/15.
//  Copyright © 2016年 wenze. All rights reserved.
//

let SQLITENAME = "GOODSLIST.sqlite"

import UIKit

class DBManage: NSObject {
    // 单例
    static let sharedInstance = DBManage()
    
    var _path: String?
    
    var _dataBase: FMDatabase?
    
    
    override init() {
        super.init()
        
        let state = self.initializeDBWithName(name: SQLITENAME)
        if state == -1 {
            print("数据库初始化失败")
        } else {
            print("数据库初始化成功")
        }
    }
    
    
    /// 初始化数据库操作
    /// @param name 数据库名称
    /// @return 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
    func initializeDBWithName(name: String) -> NSInteger {
        if name.isEmpty {
            return -1
        }
        
        // 沙盒目录
        let docp: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        _path = docp + "/" + name
        
        let fileManager = FileManager.default
        
        let hasFile = fileManager.fileExists(atPath: docp)
        
        self.connect()
        
        if !hasFile {
            return 0
        } else {
            return 1
        }
    }
    
    
    func connect() -> Void {
        if _dataBase == nil {
            _dataBase = FMDatabase(path: _path)
        }
        
        if !((_dataBase?.open())!) {
            print("不能打开数据库")
        }
    }
    
    // 关闭数据库
    func close() -> Void {
        _dataBase?.close()
    }
    
}
