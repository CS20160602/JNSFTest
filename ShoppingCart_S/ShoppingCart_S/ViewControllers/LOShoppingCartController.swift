//
//  LOShoppingCartController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOShoppingCartController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    var cartList:[LOGoodsModel] = [] // 购物车列表
    var ShoppingCartCellName = "LOShoppingCartCell"
    //MARK: -获得购物车列表数据-
    func readData() -> Void {
        let db = LOGoodsDetailDB()
        db.createDataTable()
        
        let array = db.selectAll()
        self.cartList = array as! [LOGoodsModel]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readData()
        let stringTitle = "购物车\(self.cartList.count)"
        self.initTitle(title: stringTitle as NSString)
        self.navigationController?.isNavigationBarHidden = true
        
        // 添加通知    就像农村广播， 一个地方广播， 只要你家安装喇叭里就能接受到通知
        // 播放结束之后系统会发出通知, 我们在这里注册一个通知来接收
        // 1. self 谁去执行方法
        // 2. 执行的方法
        // 3. 通知的名称
        // 4. 配置信息
        NotificationCenter.default.addObserver(self, selector: #selector(LOShoppingCartController.showAlert), name: NSNotification.Name(rawValue: "不能再少了哦~"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LOShoppingCartController.deleteGoods), name: NSNotification.Name(rawValue: "删除商品"), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.removeObserver("不能再少了哦~")
        NotificationCenter.default.removeObserver("删除商品")
    }
    
    func showAlert(noti: Notification) -> Void {
        let string: NSString = noti.object! as! NSString
        ToolUtility.createToastView(withContent: string as String!, withSuperView: self.view, andFrame: CGRect.zero)
    }
    
    func deleteGoods(noti: Notification) -> Void {
        let title: NSString = noti.object! as! NSString
        let db: LOGoodsDetailDB = LOGoodsDetailDB()
        db.createDataTable()
        db.deleteDetailWithTitle(detailTitle: title as String)
        self.readData()
        let stringTitle = "购物车\(self.cartList.count)"
        self.initTitle(title: stringTitle as NSString)
        self.mainTableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        self.initBackButton(imgName: nil)
        
        //  注册cell
        self.mainTableView.register(UINib.init(nibName: ShoppingCartCellName, bundle: nil), forCellReuseIdentifier: ShoppingCartCellName)
        
    }

    //MARK: - tableview delegate -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: LOGoodsModel = self.cartList[indexPath.row]
        let cell:LOShoppingCartCell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCellName, for: indexPath) as! LOShoppingCartCell
        cell.setDataWithModel(model: model, andResultRequest: {
            (isChange: Bool, model: LOGoodsModel) -> Void in
            if isChange == true {
                self.mainTableView.reloadData()
            }
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
