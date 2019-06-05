//
//  UserController.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/5/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    static let shared = UserController()
    var currentUser: User?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    private init() {
        
    }
    
    func createNewUser(username: String, firstName: String, completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserID, error) in
            
            if let error = error {
                print("Fetch error \(error.localizedDescription)")
                completion(false); return
            }
            
            guard let appleUserID = appleUserID else { completion(false); return }
            
            let appleUserReference = CKRecord.Reference(recordID: appleUserID, action: .deleteSelf)
            
            let newUser = User(username: username, firstName: firstName, appleUserReference: appleUserReference)
            
            let userRecord = CKRecord(user: newUser)
            
            self.publicDB.save(userRecord, completionHandler: { (_, error) in
                
                if let error = error {
                    print("Save error \(error.localizedDescription)")
                    completion(false); return
                }
            
                self.currentUser = newUser
                
                completion(true)
            })
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("Save error \(error.localizedDescription)")
                completion(false); return
            }
            
            guard let appleUserRecordID = appleUserRecordID else { return }
            let appleUserReference = CKRecord.Reference(recordID: appleUserRecordID, action: .deleteSelf)
            let predicate = NSPredicate(format: "%K == %@", User.appleUserReferenceKey, appleUserReference)
            let query = CKQuery(recordType: User.userKey, predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("Perform query error \(error.localizedDescription)")
                    completion(false); return
                }
                
                guard let records = records, records.count != 0, let userRecord = records.first else { completion(false); return }
                
                let currentUser = User(ckRecord: userRecord)
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
}
