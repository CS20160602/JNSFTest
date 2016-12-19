//
//  BaseViewController.swift
//  ShoppingCart_S
//
//  Created by wenze on 16/12/16.
//  Copyright © 2016年 wenze. All rights reserved.
//

import UIKit

//base控制器，所有的控制器基于此控制器创建，自定义navagation一般可以写在base里面
class BaseViewController: UIViewController {

    let TITLE_BAR_HEIGHT: Int = 44
    
    //状态栏和头部
    var topView: UIView?
    //页面size
    var viewSize: CGSize?
    //页面标题
    var titleLabel: UILabel?
    //返回按钮
    var backButton: UIButton?
    //右边按钮
    var rightButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.viewSize = UIScreen.main.bounds.size
        let rectStatus: CGRect = UIApplication.shared.statusBarFrame
        if (rectStatus.size.height > 20) {
            self.viewSize = CGSize(width: (self.viewSize?.width)!, height: (self.viewSize?.height)!)
        }
        self.topView = UIView()
        self.topView?.frame = CGRect(x: 0, y: 0, width: Int((self.viewSize?.width)!), height: TITLE_AND_STATUS_BAR_HEIGHT)
        //设置头视图颜色
        self.topView?.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        self.view.addSubview(self.topView!)
        
    }
    
    func setCustomNaviViewBackgroundColor(bgColor: UIColor) -> Void {
        self.topView?.backgroundColor = bgColor
    }
    
    // MARK: - 导航栏左侧按钮初始化
    func initBackButton(imgName: NSString?) -> Void {
        let img = ("\(imgName)" as NSString)
        var imgName: NSString? = imgName
        if (img.isEqual(to: "nil")) {
            imgName = "back2"
        }else{
            imgName = imgName!
        }
        if (self.backButton?.superview != nil) {
            self.backButton?.removeFromSuperview()
        }
        self.backButton = UIButton.init(type: .custom)
        self.backButton?.frame = CGRect(x: 2, y: 20, width: TITLE_BAR_HEIGHT, height: TITLE_BAR_HEIGHT)
        self.backButton?.contentEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0)
        //内容水平对齐
        self.backButton?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.backButton?.setImage(UIImage.init(named: imgName as! String), for: UIControlState.normal)
        self.backButton?.layer.cornerRadius = (self.backButton?.frame.size.width)! / 2
        self.backButton?.clipsToBounds = true
        self.addTargetActionToBackBtn()
        
        // 添加点击效果
        self.backButton?.setTitleColor(UIColor.red, for: UIControlState.selected)
        self.backButton?.backgroundColor = UIColor.clear
        self.backButton?.isExclusiveTouch = true
        self.topView?.addSubview(self.backButton!)
        
        
    }
    
    //MARK: - 导航栏右侧按钮初始化
    func initRightButtonWithImage(image: UIImage) -> Void {
        self.rightButton = UIButton()
        self.rightButton?.frame = CGRect(x: Int((self.viewSize?.width)! - 60), y: 20, width: 60, height: TITLE_BAR_HEIGHT)
        self.rightButton?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        self.rightButton?.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        self.rightButton?.addTarget(self, action: #selector(BaseViewController.clickRightButton), for: UIControlEvents.touchUpInside)
        self.rightButton?.setImage(image, for: UIControlState.normal)
        self.rightButton?.isExclusiveTouch = true
        self.topView?.addSubview(self.rightButton!)
    }
    
    //MARK: - Title
    func initTitle(title: NSString) -> Void {
        let rightBtnWidth: CGFloat
        if self.rightButton == nil {
            rightBtnWidth = 0
        }else{
            rightBtnWidth = self.rightButton!.frame.size.width
        }
        var width: CGFloat = self.view.frame.size.width - rightBtnWidth - CGFloat(TITLE_BAR_HEIGHT)
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        //计算文字高度
        let rect = title.boundingRect(with: CGSize(width: width, height: CGFloat(TITLE_BAR_HEIGHT)), options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        width = rect.size.width
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel()
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.textColor = UIColor.white
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            self.titleLabel?.backgroundColor = UIColor.clear
            self.topView?.addSubview(self.titleLabel!)
            self.titleLabel?.isUserInteractionEnabled = true
            self.titleLabel?.isExclusiveTouch = true
        }
        
        self.titleLabel?.frame = CGRect(x: CGFloat(TITLE_BAR_HEIGHT), y: 19, width: width, height:  CGFloat(TITLE_BAR_HEIGHT))
        self.titleLabel?.text = title as String
        self.titleLabel?.center = CGPoint(x: (self.topView?.center.x)!, y: (self.titleLabel?.center.y)!)
        
        
    }
    
    
    
    //MARK: - 按钮事件 back Btn   and RightBtn
    func addTargetActionToBackBtn() -> Void {
        self.backButton?.addTarget(self, action: #selector(BaseViewController.clickBackButton), for: UIControlEvents.touchUpInside)
        self.backButton?.addTarget(self, action: #selector(BaseViewController.btnTouchUpOutside), for: UIControlEvents.touchUpInside)
        self.backButton?.addTarget(self, action: #selector(BaseViewController.btnTouchDown), for: UIControlEvents.touchUpInside)
        self.backButton?.addTarget(self, action: #selector(BaseViewController.btnTouchCancel), for: UIControlEvents.touchUpInside)
        
    }
    
    func clickBackButton(btn: UIButton) -> Void {
        if (self.navigationController?.viewControllers.count != 0) {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func btnTouchUpOutside(btn: UIButton) -> Void {
        if (btn.isEqual(self.rightButton)) {
            return
        }
        btn.backgroundColor = UIColor.clear
    }
    
    func btnTouchDown(btn: UIButton) -> Void {
        if (btn.isEqual(self.rightButton)) {
            return
        }
        btn.backgroundColor = UIColor.clear
    }
    
    func btnTouchCancel(btn: UIButton) -> Void {
        if (btn.isEqual(self.rightButton)) {
            return
        }
        btn.backgroundColor = UIColor.clear
    }
    
    func clickRightButton(btn: UIButton) -> Void {
        
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
