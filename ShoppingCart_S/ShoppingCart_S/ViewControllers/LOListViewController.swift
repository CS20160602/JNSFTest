//
//  LOListViewController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

//MARK:- 屏幕尺寸

var  NavigationBarHeight   =  44.0   //导航条高度


class LOListViewController: BaseViewController {

    var tableListIcon = "TableViewIcon"
    var colltListIcon = "CollectViewIcon"
    var moreListIcon = "more_list"
    
    var _isTableList = false
    var cycleScrollView:SView?
    var carouselArray:[String] = [] // 滚动视图列表数据源
    var listTableCtrl = LOGoodsListTableViewController()
    var listCollectCtrl = LOGoodListCollectionViewController()
    
    var mutArrList:[LOGoodsModel] = []//商品数据源

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        // 创建滚动视图
        //self.creatCycleScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _isTableList = true
        self.initRightButtonWithImage(image: (UIImage.init(named: tableListIcon))!)
//        self.initBackButton(imgName: moreListIcon as NSString)
        self.initTitle(title: "商品列表")

        
        
        //获取商品数据源
        self.getGoodsListData()
        // 创建滚动视图
        self.creatCycleScrollView()
        
        //创建商品列表控制视图
        self.createTableView()
        self.createCollectView()
        
    }
    
    func getGoodsListData() -> Void {
        let dic = [DicKey_GoodsPic : "http://image.cn.made-in-china.com/prodzip/000-ZMzTICPKnAca.jpg",
                   DicKey_GoodsTitle : "毛呢外套女中长款2016冬季韩版西装领加厚修身学院风羊毛呢大衣潮",
                   DicKey_GoodsPrice : "49.90",
                   DicKey_GoodsFee : "0",
                   DicKey_GoodsSalesNum : "100",
                   DicKey_GoodsAddr : "广东广州"]
        
        let arrPic = ["http://image.cn.made-in-china.com/prodzip/000-ZMzTICPKnAca.jpg",
        "http://pic32.nipic.com/20130821/4074953_172241428000_2.jpg",
        "http://pic1.nipic.com/20090326/2060743_081152009_2.jpg",
        "http://pic3.nipic.com/20090519/2471956_115019099_2.jpg",
        "http://a2.att.hudong.com/35/19/01300466306204133110192799554.jpg",
        "http://pic30.nipic.com/20130623/10803163_003954136170_2.jpg",
        "http://image.f600.cn/c9/a0/c9a09cab-ed2c-44aa-8d03-9c3dbc38f078.jpg",
        "http://img03.tooopen.com/images/20131017/sy_42783331233.jpg",
        "http://pic32.nipic.com/20130821/4074953_174907449001_2.jpg"]
        
        let arrTitle = ["系绳翻领毛呢外套女风衣冬装2016韩版时尚收腰显瘦百搭呢子大衣潮",
        "女士2016秋冬装韩版新款加厚加棉毛呢外套毛领收腰狐狸毛呢大衣潮",
        "麻霖文艺女装2016秋冬中国风手工盘扣长款羊毛针织开衫毛衣外套厚",
        "经典中长款复古大码外套2016秋季韩国大衣韩版宽松森系格子风衣女",
        "独家自制 复古chic玫瑰花刺绣金属亮丝透视紧身短长袖T恤 打底衫",
        "ZQ子晴秋冬装新款店主重磅来袭套头黑色修身不对称露肩螺纹毛衣女",
        "PPM美丽诺羊毛针织连衣裙2016秋冬新品黑色长袖裙子修身气质显瘦",
        "【限时包邮】云上生活韩版时尚百搭中长款套头卫衣连衣裙女L5257",
        "反季清仓羽绒服女 修身长款加厚超长过膝韩版大毛领冬装外套特价"]
        
        let arrPrice = ["49.90", "76.80","279.00", "180.00","148.00", "169.00","688.00", "158.00","389.00"]
        let arrFee = ["0", "0","10", "10","10", "10","0", "0","0"]
        let arrSalesNum = ["29", "18","20", "140","66", "808","386", "717","3375"]
        let arrAddr = ["广东东莞", "广东广州","浙江杭州", "浙江金华","广东深圳", "广东广州","山东青岛", "浙江杭州","浙江嘉兴"]
        
        let goods:LOGoodsModel = LOGoodsModel.initWithData(dataObj: dic as NSDictionary) as! LOGoodsModel
        self.mutArrList.append(goods)
        for idx in 0..<(arrPic.count - 1) {
            let mutDic = NSMutableDictionary.init(dictionary: dic)
            mutDic.setObject(arrPic[idx], forKey: DicKey_GoodsPic as NSCopying)
            mutDic.setObject(arrTitle[idx], forKey: DicKey_GoodsTitle as NSCopying)
            mutDic.setObject(arrPrice[idx], forKey: DicKey_GoodsPrice as NSCopying)
            mutDic.setObject(arrFee[idx], forKey: DicKey_GoodsFee as NSCopying)
            mutDic.setObject(arrSalesNum[idx], forKey: DicKey_GoodsSalesNum as NSCopying)
            mutDic.setObject(arrAddr[idx], forKey: DicKey_GoodsAddr as NSCopying)
            let goodsM = LOGoodsModel.initWithData(dataObj: mutDic as NSDictionary) as! LOGoodsModel
            self.mutArrList.append(goodsM)

        }
        
    }
    
    func creatCycleScrollView() -> Void {
        let viewsArray:[String] = ["1.jpg","2.jpg","3.jpg","4.jpg"]
        
        self.cycleScrollView = SView.creatSView(frame: CGRect(x: 0, y: TITLE_AND_STATUS_BAR_HEIGHT, width: Int(ScreenWidth), height: 150), imageArr: viewsArray)
        self.view.addSubview(self.cycleScrollView!)
    }
    
    //创建商品tableView列表
    func createTableView() -> Void {
        let listTableCtrl = LOGoodsListTableViewController()
        listTableCtrl.mutArrData = self.mutArrList
        listTableCtrl.view.frame = CGRect(x: 0, y: (cycleScrollView?.frame.origin.y)! + (cycleScrollView?.frame.size.height)!, width: self.view.frame.size.width, height: self.view.frame.size.height - (cycleScrollView?.frame.origin.y)! - (cycleScrollView?.frame.size.height)!)
        
        self.listTableCtrl = listTableCtrl
        self.view.addSubview(listTableCtrl.view)
    }
    
    //创建商品CollectView列表
    func createCollectView() -> Void {
        let listCollectCtrl: LOGoodListCollectionViewController = LOGoodListCollectionViewController()
        listCollectCtrl.mutArrData = self.mutArrList
        listCollectCtrl.view.frame = CGRect(x: 0, y: (cycleScrollView?.frame.origin.y)! + (cycleScrollView?.frame.size.height)!, width: self.view.frame.size.width, height: self.view.frame.size.height - (cycleScrollView?.frame.origin.y)! - (cycleScrollView?.frame.size.height)!)
        self.listCollectCtrl = listCollectCtrl
        self.listCollectCtrl.view.isHidden = true
        self.view.insertSubview(listCollectCtrl.view, belowSubview: self.listTableCtrl.view)
    }
    
    
    //MARK:-BTNEvent
    override func clickRightButton(btn: UIButton) -> Void {
        _isTableList = !_isTableList
        let image = UIImage.init(named: _isTableList ? tableListIcon : colltListIcon)
        self.rightButton?.setImage(image, for: UIControlState.normal)
        self.listTableCtrl.view.isHidden = !_isTableList
        self.listCollectCtrl.view.isHidden = _isTableList

    }
    
    override func clickBackButton(btn: UIButton) {
        
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
