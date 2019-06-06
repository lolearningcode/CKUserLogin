//
//  Entry.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit
import CloudKit

class Entry {
    var title: String
    var body: String
    var image: UIImage
    var imageData: Data? {
        return image.pngData()
    }
    let userReference: CKRecord.Reference
    var recordID: CKRecord.ID?
    
    static let entryKey = "Entry"
    static let userReferenceKey = "userReference"
    static let titleKey = "title"
    static let bodyKey = "body"
    static let imageAssetKey = "imageAsset"
    
    init(title:String, body: String, image: UIImage, userReference: CKRecord.Reference) {
        self.title = title
        self.body = body
        self.image = image
        self.userReference = userReference
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[Entry.titleKey] as? String,
        let body = ckRecord[Entry.bodyKey] as? String,
        let userReference = ckRecord[Entry.userReferenceKey] as? CKRecord.Reference,
            let imageAsset = ckRecord[Entry.imageAssetKey] as? CKAsset else { return nil }
        
        let imageData = try? Data(contentsOf: imageAsset.fileURL!)
        
        self.init(title: title, body: body, image: UIImage(data: imageData!) ?? UIImage(), userReference: userReference)
        self.recordID = ckRecord.recordID
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        let recordID = entry.recordID ?? CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: Entry.entryKey, recordID: recordID)
        
        let tempDirectory = NSTemporaryDirectory()
        let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = tempDirectoryURL.appendingPathComponent(entry.title).appendingPathExtension("jpg")
        do {
            try entry.imageData?.write(to: fileURL)
        } catch {
            print("Error image \(error.localizedDescription)")
        }
        
        let imageAsset = CKAsset(fileURL: fileURL)
        
        setValue(entry.title, forKey: Entry.titleKey)
        setValue(entry.body, forKey: Entry.bodyKey)
        setValue(entry.userReference, forKey: Entry.userReferenceKey)
        setValue(imageAsset, forKey: Entry.imageAssetKey)
        entry.recordID = recordID
    }
}
