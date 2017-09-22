//
//  DCHomeViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/21.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
let HomeTopViewHeight: CGFloat = 44.0
class DCHomeViewController: UIViewController {
    
    var floder = PublishSubject<DCFolderModel>()
    var folderName: String!
    var sliderVC:DCSliderViewController!
    var messages:[MCOIMAPMessage] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let tvb: UITableView = UITableView(frame: self.view.frame)
        tvb.register(DCHomeMessageCell.classForCoder(), forCellReuseIdentifier: "cell")
        tvb.delegate = self;
        tvb.dataSource = self;
        let topView = DCHomeListTopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: HomeTopViewHeight))
        tvb.tableHeaderView = topView
        tvb.tableFooterView = UIView()
        return tvb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsetsMake(64, 0, 49, 0))
        }
    
//        _ = floder.distinctUntilChanged().subscribe(onNext: { [weak self](floder) in
//            self?.folderName = floder.path
//
//            _ = DCAccountManager.shareInstance.fetchMessege(floder: floder.path).subscribe(onNext: { (arr) in
//                    self?.messages = arr
//                }, onError: { (err) in
//
//                }, onCompleted: nil, onDisposed: nil)
//
//                }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DCHomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.messages[indexPath.row].header.from.displayName
        cell.detailTextLabel?.text = self.messages[indexPath.row].header.subject
        
        let header = self.messages[indexPath.row].header
        print(header?.subject ?? "")
//       _ = DCAccountManager.shareInstance.fetchPlainTextBody(message: self.messages[indexPath.row], folder: self.folderName).subscribe(onNext: { (str) in
//            print(str)
//        }, onError: { (err) in
//            
//        }, onCompleted: nil, onDisposed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DCMailDetailViewController()
        vc.message = self.messages[indexPath.row]
        vc.folder = self.folderName
        vc.hidesBottomBarWhenPushed = true
        self.sliderVC.navigationController?.pushViewController(vc, animated: true)
    }
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset)
        if scrollView.contentOffset.y < HomeTopViewHeight/2 {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }else if scrollView.contentOffset.y > HomeTopViewHeight/2 && scrollView.contentOffset.y < HomeTopViewHeight{
            
            scrollView.setContentOffset(CGPoint(x: 0, y: HomeTopViewHeight), animated: true)
            
        }
    }
    
}
