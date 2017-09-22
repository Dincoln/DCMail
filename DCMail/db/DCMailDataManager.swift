//
//  DCMailModelManager.swift
//  DCMail
//
//  Created by Dincoln on 2017/7/25.
//  Copyright © 2017年 Dincoln. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
class DCMailDataManager: NSObject {
    
    static let shareInstance = DCMailDataManager()
    
    var context: NSManagedObjectContext!
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DCMail")
        let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/db.sqlite")
        do{
            try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL(fileURLWithPath: file!), options: nil)
        }catch _{
            
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private override init() {
        super.init()
        self.context = self.persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetchAllAccount() -> [DCAccountModel]?{
        let req = NSFetchRequest<DCAccount>(entityName: "DCAccount")
        DCAccountManager.shareInstance.accountModels = []
        do {
            let arr = try self.context.fetch(req)
            for account in arr {
                DCAccountManager.shareInstance.accountModels.append(DCAccountModel(account: account))
            }
            return DCAccountManager.shareInstance.accountModels
        } catch  {
            return nil
        }
    }
    public func insertAccount(with accountModel: DCAccountModel){
        let account = NSEntityDescription.insertNewObject(forEntityName: "DCAccount", into: self.context) as! DCAccount
        account.fetchPort = accountModel.fetchPort!
        account.fetchHost = accountModel.fetchHost!
        account.sendHost = accountModel.sendHost!
        account.sendPort = accountModel.sendPort!
        account.username = accountModel.username!
        account.password = accountModel.password!
        account.ssl = accountModel.ssl!
        self.saveContext()
        accountModel.account = account
    }
}


