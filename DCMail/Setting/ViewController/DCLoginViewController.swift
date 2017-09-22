//
//  DCLoginViewController.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/26.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
class DCLoginViewController: UIViewController {
    var naviView: UIView!
    
    var bottomView: UIView!
    
    var usernameTextField: UITextField!
    
    var passwordTextField: UITextField!
    
    var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10.0

    }
    
    func setupSubViews() -> Void {
        self.naviView = UIView()
        self.view.addSubview(self.naviView)
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.colors = [UIColor.white, UIColor.white.withAlphaComponent(0.3)]
        layer.frame = self.naviView.frame
        self.naviView.layer.addSublayer(layer)
        self.naviView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.top.equalTo(self.view.snp.top)
            maker.height.equalTo(64.0)
        }
        
        let leftBtn = UIButton()
        self.naviView.addSubview(leftBtn)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.naviView.snp.left).offset(10)
            maker.centerY.equalTo(self.naviView.snp.centerY).offset(15)
            maker.size.equalTo(CGSize(width: 44, height: 44))
        }
        _ = leftBtn.rx.tap.subscribe(onNext: { [weak self]() in
            self?.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)

        
        let titleLable = UILabel()
        self.view.addSubview(titleLable)
        titleLable.text = "添加账号"
        titleLable.textAlignment = .center
        titleLable.font = UIFont.systemFont(ofSize: 20)
        titleLable.textColor = UIColor.black
        titleLable.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view.snp.centerX)
            maker.size.equalTo(CGSize(width: 200, height: 40))
            maker.top.equalTo(self.naviView.snp.bottom).offset(30)
        }
        
        let loadView = DCLoginLoadingView()
        self.view.addSubview(loadView)
        loadView.isHidden = true
        loadView.snp.makeConstraints { (maker) in
            maker.center.equalTo(titleLable)
            maker.size.equalTo(CGSize(width: 150, height: 50))
        }
        
        self.usernameTextField = UITextField()
        self.usernameTextField.placeholder = "账号"
        self.usernameTextField.text = "758609687@qq.com"
        self.usernameTextField.delegate  = self
        self.usernameTextField.returnKeyType = .next
        self.usernameTextField.keyboardType = .emailAddress
        self.view.addSubview(self.usernameTextField)
        self.usernameTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.snp.left).offset(20)
            maker.right.equalTo(view.snp.right).offset(0)
            maker.height.equalTo(50)
            maker.top.equalTo(titleLable.snp.bottom).offset(50)
        }
        
        self.passwordTextField = UITextField()
        self.passwordTextField.delegate = self
        self.passwordTextField.placeholder = "密码"
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .default
        self.passwordTextField.text = "jdovnvfripzwbfib"
        self.view.addSubview(self.passwordTextField)
        self.passwordTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.snp.left).offset(20)
            maker.right.equalTo(view.snp.right).offset(0)
            maker.height.equalTo(50)
            maker.top.equalTo(self.usernameTextField.snp.bottom).offset(10)
        }

        ///登陆按钮
        self.loginBtn = UIButton()
        self.view.addSubview(loginBtn)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.backgroundColor = UIColor.blue
        loginBtn.layer.cornerRadius = 6
        loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(20)
            maker.right.equalTo(self.view.snp.right).offset(-20)
            maker.height.equalTo(44)
            maker.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
        }
        _ = loginBtn.rx.tap.subscribe(onNext: { [weak self]() in
            titleLable.isHidden = true
            loadView.isHidden = false
            self?.loginBtn.isEnabled = false
            _ = DCAccountManager.shareInstance.checkAccount(username: (self?.usernameTextField.text)!, password: (self?.passwordTextField.text)!).subscribe(onNext: { [weak self](account) in
                titleLable.isHidden = false
                loadView.isHidden = true
                self?.navigationController?.popViewController(animated: true)
                }, onError: { (error) in
                    print(error)
                    self?.loginBtn.isEnabled = true
                    titleLable.isHidden = false
                    loadView.isHidden = true
            }, onCompleted: nil, onDisposed: nil)
            }, onError: nil, onCompleted: nil, onDisposed: nil)

        
        ///登陆按钮enble处理
        _ = Observable.combineLatest(self.usernameTextField.rx.text, self.passwordTextField.rx.text) { (text1, text2) -> Bool in
            return ((text1?.characters.count)! > 0 && (text2?.characters.count)! > 0)
            }.distinctUntilChanged().subscribe(onNext: { [weak self](enble) in
                if enble{
                    self?.loginBtn.alpha = 1.0
                    self?.loginBtn.isEnabled = true
                }else{
                    self?.loginBtn.alpha = 0.5
                    self?.loginBtn.isEnabled = false
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)

    }

    //     MARK: - Event
    func leftAction(btn:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension DCLoginViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = self.loginBtn.frame.maxY - self.usernameTextField.frame.maxY + 10
        }
        if textField == self.passwordTextField {
            IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = self.loginBtn.frame.maxY - self.passwordTextField.frame.maxY + 10
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10.0
        return true
    }
}
