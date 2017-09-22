//
//  DCAccountManager.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/24.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import RxSwift
import CoreData
import RxCocoa
class DCAccountManager: NSObject {
    static let shareInstance = DCAccountManager()
    
    private override init() {
        super.init()
    }    
    var accountModels: [DCAccountModel] = []

    func fetchAllFloder(accountModel: DCAccountModel) -> PublishSubject<[DCFolderModel]>{
        let op = accountModel.imapSession.fetchAllFoldersOperation()
        let foldersSubject = PublishSubject<[DCFolderModel]>()

        op?.start({(error, arr) in
            if error == nil{
                let models = DCFolderModel.transform(folders: arr as! [MCOIMAPFolder])
                foldersSubject.onNext(models)
            }else{
                foldersSubject.onError(error!)
            }
            foldersSubject.onCompleted()
        })
        return foldersSubject
    }
    
    
    func fetchMessege(floder:String, accountModel: DCAccountModel) -> PublishSubject<[MCOIMAPMessage]> {
        let messagesSubject = PublishSubject<[MCOIMAPMessage]>()
        let set = MCOIndexSet(range: MCORange(location: 1, length: UInt64.max))
        let op = accountModel.imapSession.fetchMessagesOperation(withFolder: floder, requestKind: [MCOIMAPMessagesRequestKind(rawValue: 0),MCOIMAPMessagesRequestKind(rawValue: 1),MCOIMAPMessagesRequestKind(rawValue: 2),MCOIMAPMessagesRequestKind(rawValue: 3),MCOIMAPMessagesRequestKind(rawValue: 4),MCOIMAPMessagesRequestKind(rawValue: 5)], uids: set)
        op?.start({(err, arr, set) in
            if err == nil{
                let array = arr as! [MCOIMAPMessage]
                messagesSubject.onNext(array)
            }else{
                messagesSubject.onError(err!)
            }
            messagesSubject.onCompleted()
        })
        return messagesSubject
    }
    
    func fetchMessageHTML(message:MCOIMAPMessage, folder:String, accountModel: DCAccountModel) -> PublishSubject<String> {
        let messageDetailSubject = PublishSubject<String>()
        let op = accountModel.imapSession.htmlBodyRenderingOperation(with: message, folder: folder)
        op?.start({ (string, err) in
            if err == nil{
                messageDetailSubject.onNext(string!)
            }else{
                messageDetailSubject.onError(err!)
            }
            messageDetailSubject.onCompleted()
        })
        return messageDetailSubject
    }
    
    func fetchPlainTextBody(message:MCOIMAPMessage, folder:String, accountModel: DCAccountModel) -> PublishSubject<String> {
        let plainTextSubject = PublishSubject<String>()
        let op = accountModel.imapSession.plainTextRenderingOperation(with: message, folder: folder)
        op?.start({ (string, error) in
            if error == nil{
                plainTextSubject.onNext(string!)
            }else{
                plainTextSubject.onError(error!)
            }
            plainTextSubject.onCompleted()
        })
        return plainTextSubject
    }
    
    func checkAccount(username: String, password: String) -> PublishSubject<DCAccountModel>{
        let subject = PublishSubject<DCAccountModel>()
        for accountModel in self.accountModels {
            if accountModel.username == username{
                let error = NSError(domain: "已添加该账号", code: 0, userInfo: nil)
                subject.onError(error)
                subject.onCompleted()
                return subject
            }
        }
        let path = Bundle.main.path(forResource: "Emails", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!) as! Dictionary<String, Dictionary<String, AnyObject>>
        var support = false
        let accountModel = DCAccountModel()
        for (key, value) in dic {
            if username.contains(key) {
                accountModel.fetchHost = value["fetchHost"] as? String
                accountModel.fetchPort = value["fetchPort"] as? Int32
                accountModel.sendHost = value["sendHost"] as? String
                accountModel.sendPort = value["sendPort"] as? Int32
                accountModel.username = username
                accountModel.password = password
                accountModel.connectionType = MCOConnectionType.TLS
                accountModel.ssl = value["ssl"] as? Bool
                support = true
                break
            }
        }
        
        if !support {
            let error = NSError(domain: "不支持该账号", code: 0, userInfo: nil)
            subject.onError(error)
            subject.onCompleted()
            return subject
        }
        
        let checkOperation:MCOIMAPOperation =  accountModel.imapSession.checkAccountOperation()
        checkOperation.start { [weak self](error) in
            if let err = error{
                subject.onError(err)
            }else{
                DCMailDataManager.shareInstance.insertAccount(with: accountModel)
                self?.accountModels.append(accountModel)
                subject.onNext(accountModel)
            }
            subject.onCompleted()
        }
        return subject
    }
}


