//
//  DCFolderModel.swift
//  DCMail
//
//  Created by Dincoln on 2017/8/10.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCFolderModel: NSObject {
    var path: String!
    
    var name:String!
    
    public class func transform(folders: [MCOIMAPFolder]) -> [DCFolderModel] {
        var models: [DCFolderModel] = []
        for folder in folders {
            let model = DCFolderModel()
            model.path = folder.path
//            model.name = Bundle.main.localizedString(forKey: (DCAccountManager.shareInstance.account.imapSession.defaultNamespace.components(fromPath: model.path).first as! String).uppercased(), value: "", table: nil)
            models.append(model)
        }
        models.sort { (model1, model2) -> Bool in
            if model1.path.uppercased() == "INBOX"{
                return true
            }
            if model2.path.uppercased() == "INBOX"{
                return false
            }
            return model1.name > model2.name
        }
        return models
    }
}
