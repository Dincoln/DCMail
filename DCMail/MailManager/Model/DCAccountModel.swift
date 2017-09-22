//
//  DCAccountModel.swift
//  DCMail
//
//  Created by Dincoln on 2017/8/10.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit

class DCAccountModel: NSObject {
    var name: String!
    
    var fetchHost: String?{
        didSet{
            self.imapSession.hostname = fetchHost
        }
    }

    var fetchPort:Int32?{
        didSet{
            self.imapSession.port = UInt32(fetchPort!)
        }
    }
    var sendHost: String?{
        didSet{
            
            
        }
        
    }
    var sendPort: Int32? {
        didSet{

        }
    }

    var username: String?{
        didSet{
            self.imapSession.username = username
        }
    }

    var password: String?{
        didSet{
            self.imapSession.password = password
        }
    }
    
    var ssl: Bool?{
        didSet{
            
            
        }
    }
    
    var connectionType: MCOConnectionType?{
        didSet{
            self.imapSession.connectionType = connectionType!
        }
    }
    let imapSession = MCOIMAPSession()
    
    var account: DCAccount?
    
    convenience init(account: DCAccount){
        self.init()
        self.account = account;
        self.fetchPort = account.fetchPort
        self.fetchHost = account.fetchHost
        self.sendHost = account.sendHost
        self.sendPort = account.sendPort
        self.username = account.username
        self.password = account.password
        self.ssl = account.ssl
    }
}
