//
//  DCLoginLoadingView.swift
//  DCMail
//
//  Created by Dincoln on 2017/9/21.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCLoginLoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
     init() {
        super.init(frame: CGRect.zero)
        self.setupSubView()
    }
    
    func setupSubView() {
        let im = UIImageView(image: UIImage(named: "login_loading_36x36_"))
        self.addSubview(im)
        im.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.centerY.equalTo(self)
            maker.height.equalTo(44)
            maker.width.equalTo(44)
        }
        let ani = CABasicAnimation(keyPath: "transform.rotation.z")
        ani.duration = 0.5
        ani.fromValue = 0.0
        ani.toValue = Double.pi * 2
        ani.isRemovedOnCompletion = false
        ani.repeatCount = Float.greatestFiniteMagnitude
        im.layer.add(ani, forKey: "rotation")
        
        let lab = UILabel()
        lab.text = "正在登陆..."
        lab.textColor = UIColor.darkGray
        lab.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(lab)
        lab.textAlignment = .left
        lab.snp.makeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(im.snp.right)
        }

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
