//
//  DCHomeLeftViewModel.swift
//  DCMail
//
//  Created by Dincoln on 2017/9/22.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class DCHomeLeftViewModel: NSObject {
    fileprivate var privateAccountModel: [DCAccountModel]!
    convenience override init() {
        self.init()
        self.privateAccountModel =  self.fetchAllAccount()
    }
    
    func fetchAllAccount() -> [DCAccountModel] {
        return DCMailDataManager.shareInstance.fetchAllAccount()!

    }
}

extension Reactive where Base: DCHomeLeftViewModel {
    
    var accountModel: UIBindingObserver<Base, [DCAccountModel]> {
        return UIBindingObserver(UIElement: self.base) { UIElement, value in
            UIElement.privateAccountModel = value
        }
        
    }
}
