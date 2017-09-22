//
//  DCTabBarViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/21.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCTabBarViewController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewController()
        // Do any additional setup after loading the view.
    }
    func initViewController() -> Void {
        self.tabBar.tintColor = UIColor.blue
        let homeVC = DCSliderViewController(mainVC: DCHomeViewController(), leftVC: DCHomeLeftViewController())
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem.title = "首页";
        homeNavi.tabBarItem.image = UIImage(named: "tabbar_mail_21x21_")
        homeNavi.tabBarItem.selectedImage = UIImage(named: "tabbar_mail_selected_21x21_")
        
        let settingVC = DCSettingViewController()
        let settingNav = UINavigationController(rootViewController: settingVC)
        settingNav.tabBarItem.title = "设置"
        settingNav.tabBarItem.image = UIImage(named: "tabbar_setting_21x21_")
        settingNav.tabBarItem.selectedImage = UIImage(named: "tabbar_setting_selected_21x21_")
        self.viewControllers = [homeNavi,settingNav]
    
        
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
