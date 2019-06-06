//
//  User.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/5/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import Foundation
import CloudKit

class User {
    let username: String
    let firstName: String
    let appleUserReference: CKRecord.Reference
    var recordID: CKRecord.ID?
    
    static let userKey = "User"
    static let appleUserReferenceKey = "appleUserReference"
    fileprivate static let userNameKey = "username"
    fileprivate static let firstNameKey = "firstName"
    
    init(username: String, firstName: String, appleUserReference: CKRecord.Reference) {
        self.username = username
        self.firstName = firstName
        self.appleUserReference = appleUserReference
    }
    
    init?(ckRecord: CKRecord) {
        guard let username = ckRecord[User.userNameKey] as? String, let firstName = ckRecord[User.firstNameKey] as? String, let appleUserReference = ckRecord[User.appleUserReferenceKey] as? CKRecord.Reference else { return nil }
        self.username = username
        self.firstName = firstName
        self.appleUserReference = appleUserReference
        self.recordID = ckRecord.recordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        let recordID = user.recordID ?? CKRecord.ID(recordName: UUID().uuidString)
        
        self.init(recordType: User.userKey, recordID: recordID)
        self.setValue(user.username, forKey: User.userNameKey)
        self.setValue(user.firstName, forKey: User.firstNameKey)
        self.setValue(user.appleUserReference, forKey: User.appleUserReferenceKey)
        user.recordID = recordID
    }
}
