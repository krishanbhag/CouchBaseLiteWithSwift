# CouchBaseLiteWithSwift
Demo Application depicting the operations using CouchBaseLite and Swift Language.

Couchbase Lite on iOS provides support for creating model objects that persist to Couchbase Lite documents, and can be queried using Couchbase Lite queries. (This functionality is similar to Core Data's NSManagedObject.) You subclass the abstract class CBLModel and add your own Objective-C properties, plus a very small amount of annotation that defines how those properties map to JSON in the document.

This demo mainly demonstrates Model concept of CouchBaseLite using Swift Language.

Some pointers to lookout for.

UserDetailModel is a subclass of CBLModel. which I have used for CRUD operations.
CouchBaseDataManager is used for setting up database. To sync with server please provide valid 'kSyncGatewayUrl','kSyncusername' and 'kSyncpassword'.

PS : This is still in developing stage, this demo is just to help in building an swift app using CouchBaseLiteModel.











