//
//  UserDetailModel.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit
final class UserDetailModel: CBLModel {
    
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var companyName: String?
    @NSManaged var emailId: String?
    @NSManaged var homeAddress: String?
    @NSManaged var industry: String?
    @NSManaged var usertype: String?
    @NSManaged var skills : String?
    
    //However we know its not good practice to store this info,
    @NSManaged var cardNumber : String?
    @NSManaged var expirtyDate : String?
    @NSManaged var cvvNumber : String?


    class func queryTechnician(db: CBLDatabase,withName name:String!, andPhone phone:String!) -> CBLQuery {
        let view  = CouchBaseDataManager.sharedInstance.database.viewNamed("user")
        let block: CBLMapBlock = {(doc, emit) in
            let na:String = doc["name"] as! String
            let ph:String = doc["phoneNumber"] as! String
            
            if na.characters.count > 0 && ph.characters.count > 0 && na == name && phone == ph{
                emit(doc,doc)
            }
        }
        view.setMapBlock(block, version: "1")
        return view.createQuery()
   }
   class func queryTechnicianDocument() -> CBLQuery {
        let view  = CouchBaseDataManager.sharedInstance.database.viewNamed("listUser")
        let block: CBLMapBlock = {(doc, emit) in
                emit(doc,doc)
        }
        view.setMapBlock(block, version: "1")
        return view.createQuery()
    }
    class func retrieveTechnician(name:String!,andPhone phone:String! , fromDb database: CBLDatabase) -> Array<UserDetailModel>{
        do {
            let listQuery = queryTechnician(db: database, withName:name, andPhone: phone)
            let result = try listQuery.run()
            print("Count of rows:\(result.count)");
            var technicianModelArray = [UserDetailModel]()
            for (_, row) in result.enumerated() {
                let techDocument : CBLDocument = (row as! CBLQueryRow).document!
                let model:UserDetailModel = UserDetailModel(for:techDocument)!
                technicianModelArray.append(model)
                print("Product name \(model.name) index : \(model.phoneNumber)")
            }
            return technicianModelArray
        }
        catch {
            print("query failed with error \(error.localizedDescription)")
        }
        return [UserDetailModel]()
    }
    class func retrieveTechnicianUsers() -> Array<UserDetailModel>{
        do {
            let listQuery = queryTechnicianDocument()
            let result = try listQuery.run()
            print("Count of rows:\(result.count)");
            var technicianModelArray = [UserDetailModel]()
            for (_, row) in result.enumerated() {
                let techDocument : CBLDocument = (row as! CBLQueryRow).document!
                let model:UserDetailModel = UserDetailModel(for:techDocument)!
                technicianModelArray.append(model)
                print("user name \(model.name) index : \(model.phoneNumber)")
            }
            return technicianModelArray
        }
        catch {
            print("query failed with error \(error.localizedDescription)")
        }
        return [UserDetailModel]()

    }
    class func saveTechnicianInfoIfNotExists(Object: UserDetailModel) -> Void {
        do {
            try Object.save()
        }
        catch {
            print("Document cannot be saved: Error \(error.localizedDescription)")
        }
    }
    class func deleteTechnicianObject(Object: UserDetailModel) -> Void {
        do {
            try Object.deleteDocument()
        }
        catch {
            print("Document cannot be saved: Error \(error.localizedDescription)")
        }
    }
}
