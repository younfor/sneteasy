//
//  ViewController.swift
//  cqbbs
//
//  Created by y on 15/11/29.
//  Copyright © 2015年 y. All rights reserved.
//

import UIKit

class CQDrawerViewController: UIViewController {

    var mainController:UIViewController?
    var leftController:UIViewController?
    var rightController:UIViewController?
    
    // 滑动宽度
    var leftWidth:CGFloat = 200
    var rightWidth:CGFloat = 200
    // 缩放大小
    var leftScaleHeigth:CGFloat = 50
    var rightScaleHeigth:CGFloat = 50
    var isMoving:Bool = false
    // main起始位置
    var originx:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // 当前控制器是父类
        self.view.backgroundColor = UIColor.blueColor()
        // 增加子控制器
        if self.mainController == nil {
            print("主视图为空")
        } else {
            self.addChildViewController(mainController!)
        }
        if (self.leftController != nil) {
            self.addChildViewController(leftController!)
        }
        if (self.rightController != nil) {
            self.addChildViewController(rightController!)
        }
        // 显示主视图
        self.view.addSubview((self.mainController?.view)!)
        // 绑定手势
        let recoginizer = UIPanGestureRecognizer.init(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(recoginizer)
        let tap1 = UITapGestureRecognizer.init(target: self, action: "handleTap:")
        let tap2 = UITapGestureRecognizer.init(target: self, action: "handleTap:")
        self.leftController?.view.addGestureRecognizer(tap1)
        self.rightController?.view.addGestureRecognizer(tap2)
        // 通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLeftSide", name: "showleft", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showRightSide", name: "showright", object: nil)
        
   
    }
    func showLeftSide() {
        self.view.addSubview((self.leftController?.view)!)
        self.view.sendSubviewToBack((self.leftController?.view)!)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainController?.view.frame = CGRectMake(leftWidth, leftScaleHeigth, (self.view.frame.width), (self.view.frame.height)-2*self.leftScaleHeigth)
        })
    }
    func showRightSide() {
        self.view.addSubview((self.rightController?.view)!)
        self.view.sendSubviewToBack((self.rightController?.view)!)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainController?.view.frame = CGRectMake(-rightWidth, rightScaleHeigth, (self.view.frame.width), (self.view.frame.height)-2*self.rightScaleHeigth)
        })
        
    }
    // tap手势
    func handleTap(recognizer:UIPanGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainController?.view.frame = CGRectMake(0, 0, (self.view.frame.width), (self.view.frame.height))
            },completion: { (bool:Bool) -> Void in
                    self.leftController?.view.removeFromSuperview()
                    self.rightController?.view.removeFromSuperview()
        })
    }
    // 滑动手势
    func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let trans = recognizer.translationInView(self.view)
        
        // 滑动x距离
        var x:CGFloat = trans.x
        if recognizer.state == UIGestureRecognizerState.Began {
            // 滑动开始
            originx = self.mainController!.view.frame.origin.x
            isMoving = true
            if ((self.leftController != nil)) {
                self.view.addSubview((self.leftController?.view)!)
                self.view.sendSubviewToBack((self.leftController?.view)!)
            }
            if ((self.rightController != nil)) {
                self.view.addSubview((self.rightController?.view)!)
                self.view.sendSubviewToBack((self.rightController?.view)!)
            }
        } else if recognizer.state == UIGestureRecognizerState.Ended {
            // 滑动结束
            var flag:CGFloat = 1.0
            if self.mainController?.view.frame.origin.x > 0.5 * leftWidth && self.mainController?.view.frame.origin.x > 0{
                x = leftWidth - originx
                flag = 1.0
            } else if self.mainController?.view.frame.origin.x < 0 && self.mainController?.view.frame.origin.x < -0.5 * rightWidth {
                x = rightWidth - originx
                flag = -1.0
            } else {
                originx = 0
                x = 0
                flag = 0
            }
            var y:CGFloat=0
            var height:CGFloat = (self.view.frame.height)
            if flag > 0 {
                y = leftScaleHeigth
            } else if flag < 0 {
                y = rightScaleHeigth
            }
            height -= 2*y
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.mainController?.view.frame = CGRectMake(flag*(originx + x), y, (self.mainController?.view.frame.width)!, height)
                },completion: { (bool:Bool) -> Void in
                    if (self.originx + x == 0) {
                        self.leftController?.view.removeFromSuperview()
                        self.rightController?.view.removeFromSuperview()
                    }
                }
            )
            isMoving = false
        }
        

        // 右滑超过范围
        if (leftController != nil) && (trans.x > 0 && self.mainController?.view.frame.origin.x > leftWidth) {
            recognizer.setTranslation(CGPointMake(leftWidth-originx, 0), inView: self.view)
        }
        // 左滑超过范围
        else if (rightController != nil) && trans.x < 0 && self.mainController?.view.frame.origin.x < -rightWidth {
            recognizer.setTranslation(CGPointMake(originx-rightWidth, 0), inView: self.view)
        }
        // 正在滑动
        else if isMoving {
            // 无左侧栏
            if (leftController == nil) && (originx+x > 0){
                return
            }
            // 无右侧栏
            if (rightController == nil) && (originx+x < 0){
                return
            }
            var y:CGFloat=0
            // 左侧栏打开
            if (self.mainController?.view.frame.origin.x>0) {
                y = leftScaleHeigth * ((self.mainController?.view.frame.origin.x)! / leftWidth)
                self.rightController?.view.removeFromSuperview()
                if self.view.subviews.count == 1 {
                    self.view.addSubview((self.leftController?.view)!)
                    self.view.sendSubviewToBack((self.leftController?.view)!)
                }
            } else if (self.mainController?.view.frame.origin.x<0) {
            // 右侧栏打开
                y = rightScaleHeigth * (-(self.mainController?.view.frame.origin.x)! / rightWidth)
                self.leftController?.view.removeFromSuperview()
                if self.view.subviews.count == 1 {
                    self.view.addSubview((self.rightController?.view)!)
                    self.view.sendSubviewToBack((self.rightController?.view)!)
                }
            }
            var height:CGFloat = (self.view.frame.height)
            height -= 2*y
            self.mainController?.view.frame = CGRectMake(originx + x, y, (self.mainController?.view.frame.width)!,height)
        }
    }
    
    // 状态栏字体颜色白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

