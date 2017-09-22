//
//  DCHomeLeftViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/21.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class DCHomeLeftViewController: UIViewController {

    var homeVC: DCHomeViewController!
    let viewModel = DCHomeLeftViewModel()
    var closeBlock: (()->Void)!
    lazy var tableView: UITableView = {
        let tvb = UITableView(frame: self.view.frame)
        tvb.delegate = self;
        tvb.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tvb.dataSource = self;
        return tvb
    }()
     var floders:[DCFolderModel] = []{
        didSet{
            self.tableView.reloadData()
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsetsMake(64, 0, 49, 0))
        }
    
        let sub = viewModel.rx.accountModel.as
        
    }

}

extension DCHomeLeftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.floders.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.floders[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.homeVC.floder.onNext(self.floders[indexPath.row])
        if self.closeBlock != nil{
            self.closeBlock()
        }
    }
    
}

