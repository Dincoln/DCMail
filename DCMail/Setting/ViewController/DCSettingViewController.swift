//
//  DCSettingViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/21.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCSettingViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tvb = UITableView(frame: self.view.frame)
        tvb.delegate = self;
        tvb.dataSource = self;
        return tvb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension DCSettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "账号"
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(DCAccountViewController(), animated: true)
            break
        default:
            break
        }
    }
    
    
}

