//
//  SharedFile.swift
//  Tokyo
//
//  Created by Hugo Prinsloo on 2018/10/14.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

enum FileType {
    case image
}

protocol SharedFile {
    var type: FileType { get }
}

struct Image: SharedFile {
    
    var type: FileType {
        get {
            return .image
        }
    }
    
    let image: UIImage
    let title: String?
}

class FileManager {
    
    struct Keys {
        static let recordType = "SharedFile"
    }
    
    private var items: [SharedFile] = []

    private let container = CKContainer.default()
    
    func fetch(completion: @escaping (_ success: Bool) -> Void) {
        items = DummyData.items
        completion(true)
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: Keys.recordType, predicate: predicate)
//
//        container.privateCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
//            if let records = records {
//                var i: [SharedFile] = []
//                for record in records {
//                    i.append(Image(record: record))
//                    if i.count == records.count {
//                        completion(i)
//                    }
//                }
//            }
//        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> SharedFile {
        return items[index]
    }

    
    func add(_ item: SharedFile, completion: @escaping (_ success: Bool) -> Void) {
        items.insert(item, at: 0)
        completion(true)
//        switch item.type {
//        case .image:
//            add(image: item as! Image) { (success) in
//                completion(success)
//            }
//        }
    }
    
    private func add(image: Image, completion: @escaping (_ success: Bool) -> Void) {
        
//        let jsonEncoder = JSONEncoder()
//        if let data = try? jsonEncoder.encode(image), let json = String(data: data, encoding: .utf8) {
//            let record = CKRecord(recordType: Keys.recordType)
//            record.setValue(json, forKey: Keys.recordType)
//            container.privateCloudDatabase.save(record) { (recored, error) in
//                if error == nil {
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            }
//        }
    }

        
}


