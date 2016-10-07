//
//  CouchBaseDataManager.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit

var SYNCUSERNAME: NSString!
var SYNCPASSWORD: NSString!

enum ApplicationUserState {
    case LoggedIn
    case NewUser
    case VerificationPending
    case LoggedOut
}


/// Couch DB Parameter setup
let kEncryptionEnabled = true
let kSyncEnabled = true

let kSyncGatewayUrl = NSURL(string: "YOUR_URL")! //Sync gateway url.
let kSyncusername : String = "username"  //username to sync with server
let kSyncpassword : String = "password"  //password

let kLoggingEnabled = true
let kCouchCBFileName = "userdb"

final class CouchBaseDataManager: NSObject {

    static let sharedInstance = CouchBaseDataManager()
    
    var database: CBLDatabase!
    var syncError: NSError?
    var conflictsLiveQuery: CBLLiveQuery?
    
    var pullServer : CBLReplication!
    var pushServer : CBLReplication!
    
    override init() {
        super.init()
        
        if kLoggingEnabled {
            CBLManager.enableLogging("Database")
            CBLManager.enableLogging("View")
            CBLManager.enableLogging("ViewVerbose")
            CBLManager.enableLogging("Query")
            CBLManager.enableLogging("Sync")
            CBLManager.enableLogging("SyncVerbose")
        }
        let manager = CBLManager.sharedInstance()
        do {
            try database = manager.databaseNamed(kCouchCBFileName)
            database.modelFactory?.registerClass(UserDetailModel.self, forDocumentType: "UserDetailModel")
        } catch let error as NSError {
            print("Cannot open the database: %@", error)
        }
    }
}
extension CouchBaseDataManager {
    func startReplication() -> Void {
        
        let push = database.createPushReplication(kSyncGatewayUrl as URL)
        let pull = database.createPullReplication(kSyncGatewayUrl as URL)
        push.continuous = true
        pull.continuous = true
        
        self.pullServer = pull
        self.pushServer = push
        
        NotificationCenter.default.addObserver(self, selector:  #selector(CouchBaseDataManager.replicationChanged), name: NSNotification.Name.cblReplicationChange, object: push)
        NotificationCenter.default.addObserver(self, selector:  #selector(CouchBaseDataManager.replicationChanged), name: NSNotification.Name.cblReplicationChange, object: pull)

        
//        Server authentication needed.
        var auth: CBLAuthenticatorProtocol?
        auth = CBLAuthenticator.basicAuthenticator(withName: kSyncusername, password:kSyncpassword)
        push.authenticator = auth
        pull.authenticator = auth

        self.pullServer.start()
        self.pushServer.start()
        
    }
    func replicationChanged(notification: NSNotification) {
        if (self.pullServer.status == CBLReplicationStatus.active || self.pullServer.status == CBLReplicationStatus.active) {
            print("Sync in progress")
        } else {
            
            let error = self.pullServer.lastError ?? self.pushServer.lastError
            guard error != nil else {
                return
            }
            let err:NSError = error as! NSError
            
            print("\n *** Please provide a valid url,username and password and try again : \(self.pushServer.lastError) *** \n")
            print("\n *** Please refer : http://developer.couchbase.com/documentation/mobile/1.3/get-started/sync-gateway-overview/index.html")
            
            if err.code == 401 {
                print("Authentication error")
            }
        }
    }

}
