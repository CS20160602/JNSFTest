//
//  LOGoodsListTableViewController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

class LOGoodsListTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var mutArrData:[LOGoodsModel] = []
    var tbView:UITableView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topView?.removeFromSuperview()
        self.initTableView()
        
    }
    
    func initTableView() -> Void {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let tbView:UITableView = UITableView.init(frame: rect, style: UITableViewStyle.plain)
        tbView.backgroundColor = UIColor.clear
        tbView.delegate = self
        tbView.dataSource = self
        tbView.showsHorizontalScrollIndicator = false
        tbView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.view.addSubview(tbView)
        
        self.tbView = tbView
        // 添加tableView约束
        self.configureTableView()
    }
    
    func configureTableView() -> Void {
        self.tbView?.translatesAutoresizingMaskIntoConstraints = false;
        
        let width: NSLayoutConstraint = NSLayoutConstraint.init(item: self.tbView!,
                                                                attribute: NSLayoutAttribute.width,
                                                                relatedBy: NSLayoutRelation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutAttribute.width,
                                                                multiplier: 1.0,
                                                                constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint.init(item: self.tbView!,
                                                                attribute: NSLayoutAttribute.height,
                                                                relatedBy: NSLayoutRelation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutAttribute.height,
                                                                multiplier: 1.0,
                                                                constant: 0)
        let top: NSLayoutConstraint = NSLayoutConstraint.init(item: self.tbView!,
                                                                attribute: NSLayoutAttribute.top,
                                                                relatedBy: NSLayoutRelation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutAttribute.top,
                                                                multiplier: 1.0,
                                                                constant: 0)
        let leading: NSLayoutConstraint = NSLayoutConstraint.init(item: self.tbView!,
                                                                attribute: NSLayoutAttribute.leading,
                                                                relatedBy: NSLayoutRelation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutAttribute.leading,
                                                                multiplier: 1.0,
                                                                constant: 0)
        self.view.addConstraints([width,height,top,leading])
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifyStr = "LOGoodListTableViewCell"
        var cell: LOGoodListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifyStr) as? LOGoodListTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(identifyStr, owner: self, options: nil)?.last as? LOGoodListTableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        if (self.mutArrData.count - 1) < indexPath.row {
            return cell!
        }
        
        let model:LOGoodsModel = self.mutArrData[indexPath.row]
        cell?.setCellViewsWithModel(model: model)
        
        return cell!
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell:UITableViewCell = self.tableView(tableView, cellForRowAt: indexPath)
        return cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.mutArrData.count - 1) < indexPath.row {
            return;
        }
        
        let model: LOGoodsModel = self.mutArrData[indexPath.row]
        let goodDetailVC: LOGoodsDetailViewController = LOGoodsDetailViewController()
        goodDetailVC.goodsModel = model
        AppDelegate.gaNavigationController().pushViewController(goodDetailVC, animated: true)
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
