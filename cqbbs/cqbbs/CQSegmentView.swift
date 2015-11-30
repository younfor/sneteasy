//
//  CQSegmentView.swift
//  cqbbs
//
//  Created by y on 15/11/29.
//  Copyright © 2015年 y. All rights reserved.
//

import UIKit
protocol CQSegmentDataSource:class{
    func numberOfSegment() -> Int
    func segmentObjectForNumber(number:Int) -> UIButton
    func viewControllersForNumber(number:Int) -> UIViewController
    func segmentDidSelected(number:Int)
}
class CQSegmentView: UIView,UIScrollViewDelegate {
    
    // 标签滚动条
    lazy var segmentScrollView = UIScrollView()
    // 主滚动视图
    lazy var mainScrollView = UIScrollView()
    // 标签背景
    var shadowImageView:UIImageView?
    // 正在滚动
    var isScrolling = false
    var touchX:CGFloat = 0
    // 滚动内容
    let mainViews = NSMutableArray()
    // 滑动方向
    var direction = -1 // -1左边 1右边
    // 当前选中
    let btnTagBase:Int = 100
    var currentSelected:Int = 100
    let segmentHeight:CGFloat = 44
    let segmentMargin:CGFloat = 10
    var isLayouted = false
    weak var datasource:CQSegmentDataSource?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init coder")
        self.backgroundColor = UIColor.grayColor()
        // segmentScrollView
        self.segmentScrollView.backgroundColor = UIColor.lightTextColor()
        self.segmentScrollView.showsHorizontalScrollIndicator = false
        self.segmentScrollView.delegate = self
        self.addSubview(self.segmentScrollView)
        // mainScrollView
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.mainScrollView.delegate = self
        self.mainScrollView.pagingEnabled = true
        self.mainScrollView.bounces = false
        self.addSubview(self.mainScrollView)
        // 阴影背景
        self.shadowImageView = UIImageView.init(image: UIImage.init(named: "red_line_and_shadow"))
        self.segmentScrollView.addSubview(self.shadowImageView!)

    }
    override func layoutSubviews() {
        print("layoutSubviews")
        if isLayouted == true {
            return
        }
        isLayouted = true
        print(self.frame)
        // segmentScrollView
        self.segmentScrollView.frame = CGRectMake(0, 0, self.frame.width, self.segmentHeight)
        var x = self.segmentMargin
        // buttons
        for var i=0;i<datasource?.numberOfSegment();i++ {
            let btn = datasource?.segmentObjectForNumber(i)
            if i==0 {
                self.shadowImageView?.frame = CGRectMake(self.segmentMargin, 0, (btn?.frame.width)!, self.segmentHeight - 3)
                btn?.selected = true
            }
            btn?.tag = i + self.btnTagBase
            btn?.addTarget(self, action: "onClickSegment:", forControlEvents: UIControlEvents.TouchUpInside)
            x += ((btn?.frame.width)!/2)
            btn?.center = CGPoint(x:x ,y: self.segmentHeight / 2)
            x += self.segmentMargin + ((btn?.frame.width)!/2)
            self.segmentScrollView.addSubview(btn!)
        }
        // 默认选中
        self.datasource?.segmentDidSelected(0)
        self.segmentScrollView.contentSize = CGSize(width: x,height: self.segmentHeight)
        // mainScrollView
        let mainY = CGRectGetMaxY(self.segmentScrollView.frame)
        self.mainScrollView.frame = CGRectMake(0, mainY, self.frame.width, self.frame.height - self.segmentHeight)
        // mainViews
        for var i=0;i<self.datasource?.numberOfSegment();i++ {
            let vc = (self.datasource?.viewControllersForNumber(i))!
            self.mainViews.addObject(vc)
            self.mainScrollView.addSubview(vc.view)
            let index = CGFloat(i)
            vc.view.frame = CGRectMake(index * (vc.view.frame.width), 0, vc.view.frame.width, vc.view.frame.height)
        }
        let count = (CGFloat)((self.datasource?.numberOfSegment())!)
        self.mainScrollView.contentSize = CGSizeMake( count * self.frame.width, self.mainScrollView.frame.height)
        
    }
    // 按钮选择事件
    func onClickSegment(sender:UIButton) {
        sender.selected = true
        let btn = (self.segmentScrollView.viewWithTag(self.currentSelected)) as! UIButton
        if btn.tag == sender.tag {
            return
        }
        btn.selected = false
        self.currentSelected = sender.tag
        // 标签阴影移动
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.shadowImageView!.frame = CGRectMake(sender.frame.origin.x, 0, sender.frame.width, self.segmentHeight - 3)
            }) { (bool:Bool) -> Void in
                // 新页面出来
                self.datasource?.segmentDidSelected(sender.tag-self.btnTagBase)
                if self.isScrolling == false {
                    let index:CGFloat = CGFloat(sender.tag - self.btnTagBase)
                    self.mainScrollView.contentOffset = CGPointMake(self.bounds.size.width * index,0)
                }
                self.isScrolling = false
                
        }
        self.relocationSegment(sender)
        self.setNeedsLayout()
    }
    // 修正坐标
    func relocationSegment(s:UIButton) {
        //
        let x1 = self.segmentScrollView.contentSize.width
        let x2 = s.frame.origin.x + self.frame.width + self.segmentMargin
        print("\(x1) \(x2)")
        if (x1 > x2) {
            self.segmentScrollView.setContentOffset(CGPointMake(s.frame.origin.x - self.segmentMargin, 0)
                , animated: true)
        }

    }
    // 滚动代理
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            self.touchX = scrollView.contentOffset.x
        }
    }
    // 滚动结束
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            self.isScrolling = true
            let index = (Int)(scrollView.contentOffset.x / self.bounds.width + 0.5)
            print(scrollView.contentOffset.x / self.bounds.width)
            let btn:UIButton = self.segmentScrollView.viewWithTag(index + self.btnTagBase) as! UIButton
            self.onClickSegment(btn)
            print("\(index) 滚动了:\(btn.titleLabel?.text)")
        }
    }
}
