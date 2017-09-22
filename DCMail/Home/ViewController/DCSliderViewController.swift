//
//  DCSliderViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/24.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class DCSliderViewController: UIViewController {
    weak var mainVC: DCHomeViewController!
    var leftVC: DCHomeLeftViewController!
    var panEnable = false
    var sliderFinish = false
    
    convenience init(mainVC :DCHomeViewController, leftVC :DCHomeLeftViewController) {
        self.init()
        self.mainVC = mainVC
        self.leftVC = leftVC
        self.leftVC.homeVC = self.mainVC
        self.mainVC.sliderVC = self;
        self.view.backgroundColor = UIColor.white
        self.leftVC.closeBlock = {[weak self]()->Void in
            self?.close()
        }
        self.leftVC.view.frame = CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT)
        self.view.addSubview(self.leftVC.view)

        self.mainVC.view.frame = self.view.frame
        self.mainVC.view.layer.shadowColor = RGB(r: 100, g: 100, b: 100).cgColor
        self.mainVC.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        self.view.addSubview(self.mainVC.view)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        self.view.addGestureRecognizer(pan)
        
    }
    
    
    func panAction(pan:UIPanGestureRecognizer) -> Void {
        let point = pan.location(in: self.view)
        switch pan.state {
        case .began:
            if point.x<SCREEN_WIDTH * 0.2 || self.sliderFinish{
                self.panEnable = true
            }
            break
        case .changed:
            if self.panEnable{
                self.mainVC.view.frame = CGRect(x: point.x, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                if point.x <= SCREEN_WIDTH * 0.8 {
                    self.leftVC.view.frame = CGRect(x: -SCREEN_WIDTH * 0.8 + point.x, y: 0, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT)
                }
            }
            break
        case .ended:
            if !self.panEnable {
                return;
            }
            if point.x > SCREEN_WIDTH * 0.5{
                self.sliderFinish = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainVC.view.frame = CGRect(x: SCREEN_WIDTH * 0.8, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                    self.leftVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT)
                })
            }else{
                self.sliderFinish = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                    self.leftVC.view.frame = CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT)
                })
            }
            
            break
            
        default:break
            
        }
    }
    
    func close() -> Void {
        self.sliderFinish = false
        UIView.animate(withDuration: 0.5, animations: {
            self.mainVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            self.leftVC.view.frame = CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setImage(UIImage(named: "applicationShortcut_AddAccount_35x35_"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        self.hidesBottomBarWhenPushed = false
        // Do any additional setup after loading the view.
    }
    func addAction() -> Void {
        
        self.navigationController?.pushViewController(DCSendMailViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension Reactive where Base: DCSliderViewController {
    
     var frame: UIBindingObserver<Base, CGRect?> {
        return UIBindingObserver(UIElement: self.base) { vc, frame in
            vc.view.frame = frame!
            
        }
    }
    
}

