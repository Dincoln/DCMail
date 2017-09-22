//
//  DCAccountViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/25.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCAccountViewController: UITableViewController {
    
    var accounts: [DCAccount]! = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
//        _ = DCMailDataManager.shareInstance.accountSubject.subscribe(onNext: { [weak self](arr ) in
//            self?.accounts = arr
//        }, onError: { (error) in
//
//        }, onCompleted: nil, onDisposed: nil)
//        DCMailDataManager.shareInstance.fetchAllAccount()
    }
    
    
}

extension DCAccountViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count + 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        if indexPath.row == self.accounts.count {
            cell?.textLabel?.textColor = UIColor.blue
            cell?.textLabel?.text = "新增账号"
            cell?.accessoryType = .none
        }else{
            cell?.textLabel?.textColor = UIColor.black
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.text = self.accounts[indexPath.row].username
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.accounts.count {
            self.navigationController?.pushViewController(DCLoginViewController(), animated: true)
        }
    }
}
