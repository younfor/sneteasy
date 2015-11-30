//
//  CQNewsViewController.swift
//  cqbbs
//
//  Created by y on 15/11/29.
//  Copyright © 2015年 y. All rights reserved.
//

import UIKit

class CQNewsViewController: UIViewController,CQSegmentDataSource {

   
    @IBOutlet weak var slideSwitchView: CQSegmentView!
    // 控制器s
    var controllers:NSMutableArray?
    // Segment条
    lazy var titles:NSArray = ["头条","军事","娱乐八卦","小狗狗","大猫猫","论坛","美女图片"]
    // 弹出side
    @IBAction func rightSide(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showright", object: nil)
    }
    @IBAction func leftSide(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showleft", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置子控制器
        self.controllers = NSMutableArray()
        for i in 1...7 {
            let vc = UIViewController()
            if i%2 == 0 {
                vc.view.backgroundColor = UIColor.yellowColor()
            } else {
                vc.view.backgroundColor = UIColor.greenColor()
            }
            self.controllers!.addObject(vc)
        }
        print("主视图")
        // 设置背景
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // 设置选项卡
        self.slideSwitchView.datasource = self
        self.automaticallyAdjustsScrollViewInsets = false
       
    }
    override func viewDidLayoutSubviews() {
        print("2 \(self.slideSwitchView.frame)")
        self.slideSwitchView.frame = CGRectMake(0, self.slideSwitchView.frame.origin.y, self.view.frame.width, self.slideSwitchView.frame.height)
    }
    // Segment 代理
    func numberOfSegment() -> Int {
        return (self.controllers?.count)!
    }
    func segmentDidSelected(number: Int) {

        let v:UIView = (self.controllers?[number].view!)!
        let label = UILabel.init()
        label.text = "这是\(number)"
        label.sizeToFit()
        label.center = CGPointMake(v.frame.width / 2, v.frame.height / 2)
        v.addSubview(label)
    }
    func segmentObjectForNumber(number: Int) -> UIButton {
        let btn = UIButton.init(type: UIButtonType.Custom)
        btn.setTitle(self.titles[number] as? String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btn.sizeToFit()
        return btn
    }
    func viewControllersForNumber(number: Int) -> UIViewController {
        return self.controllers?[number] as! UIViewController
    }

}
