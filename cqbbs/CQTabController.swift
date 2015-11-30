//
//  CQTabControllerViewController.swift
//  cqbbs
//
//  Created by y on 15/11/29.
//  Copyright © 2015年 y. All rights reserved.
//

import UIKit

class CQTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置字颜色
        self.setTabBarColor()
        // Do any additional setup after loading the view.
    }
    // 设置tabbar的颜色
    func setTabBarColor() {
        let viewControllers = self.viewControllers
        for viewController in viewControllers! {
            viewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.redColor()], forState: UIControlState.Selected)
        }
    }
    
}
