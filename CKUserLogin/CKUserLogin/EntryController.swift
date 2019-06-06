//
//  EntryController.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit
import CloudKit

class EntryController {
    static let shared = EntryController()
    var entries: [Entry] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func createNewEntry(title: String, body: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        
        guard let userRecordID = UserController.shared.currentUser?.recordID else { completion(false); return }
        let userReference = CKRecord.Reference(recordID: userRecordID, action: .deleteSelf)
        let entry = Entry(title: title, body: body, image: image, userReference: userReference)
        let entryRecord = CKRecord(entry: entry)
        
        self.publicDB.save(entryRecord) { (record, error) in
            
            if let error = error {
                print("Error saving \(entry.title) \(error.localizedDescription)"); completion(false); return
            }
            
            guard let record = record, let newEntry = Entry(ckRecord: record) else { completion(false); return }
            self.entries.append(newEntry)
            completion(true)
        }
    }
    
    func fetchEntriesFor(user: User, completion: @escaping (Bool) -> Void) {
        
        let userRecord = CKRecord(user: user)
        let userReference = CKRecord.Reference(record: userRecord, action: .deleteSelf)
        let predicate = NSPredicate(format: "%K == %@", Entry.userReferenceKey, userReference)
        let query = CKQuery(recordType: Entry.entryKey, predicate: predicate)
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching \(user.username) \(error.localizedDescription)"); completion(false); return
            }
            guard let records = records else { return }
            let entries = records.compactMap { return Entry(ckRecord: $0) }
            self.entries = entries
            completion(true)
        }
    }
    
    func delete(entry: Entry, completion: @escaping (Bool) -> Void) {
                
        publicDB.delete(withRecordID: entry.recordID!) { (_, error) in
            if let error = error {
                print("Error deleting \(error.localizedDescription)"); completion(false); return
            }
            completion(true)
        }
    }
}
