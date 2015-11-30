//
//  LeftViewController.swift
//  cqbbs
//
//  Created by y on 15/11/29.
//  Copyright © 2015年 y. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        let bg = UIImageView.init(image: UIImage.init(named:"sidebar_bg"))
        bg.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(bg)
    }
}
