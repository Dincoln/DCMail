//
//  DCMailDetailViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/8/1.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
class DCMailDetailViewController: UIViewController {
    var webView = UIWebView()
    var message: MCOIMAPMessage!
    var folder: String!
    var finishLoad = false
    var htmlStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.webView.scalesPageToFit = false
        self.view.addSubview(webView)
        self.webView.delegate = self
        self.webView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view.snp.edges)
        }
        self.webView.isHidden = true
        
//        _ = DCAccountManager.shareInstance.fetchMessageHTML(message: message, folder: folder).subscribe(onNext: { [weak self](str) in
//            self?.webView.loadHTMLString(str, baseURL: nil)
//            self?.htmlStr = str
//            }, onError: { (error) in
//            
//        }, onCompleted: { 
//            
//        }, onDisposed:nil)
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DCMailDetailViewController: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.finishLoad{
            self.webView.isHidden = false
            return;
        }else{
            self.finishLoad = true
            self.webView.loadHTMLString(self.htmlAdjustWithPage(), baseURL: nil)
        }
    }
    
    func htmlAdjustWithPage() -> String {
        let scale = (SCREEN_WIDTH-10)/CGFloat(Double(webView.stringByEvaluatingJavaScript(from: "document.body.scrollWidth")!)!)
        let str = "<meta name=\"viewport\" content=\" initial-scale=\(scale), minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>"
        let result = self.htmlStr.replacingOccurrences(of: "</head>", with: str, options: .literal, range: self.htmlStr.range(of: self.htmlStr))
        return result
    }
}

