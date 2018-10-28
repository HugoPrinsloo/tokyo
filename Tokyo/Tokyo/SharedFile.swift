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

struct SharedItem: Codable {
    let type: FileType
    let title: String
    let thumbnail: Data?
    let url: String?
}

enum FileType: String, Codable {
    case image = "image"
    case video = "video"
    case url = "url"
}

class FileManager {
    
    struct Keys {
        static let recordType = "SharedFile"
    }
    
    private var items: [SharedItem] = []

    private let container = CKContainer.default()
    
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> SharedItem {
        return items[index]
    }

    func add(_ item: SharedItem, completion: @escaping (_ success: Bool) -> Void) {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(item), let json = String(data: data, encoding: .utf8) {
            let record = CKRecord(recordType: Keys.recordType)
            record.setValue(json, forKey: Keys.recordType)
            container.privateCloudDatabase.save(record) { (recored, error) in
                if let error = error {
                    print(error)
                    completion(false)
                } else {
                    self.items.insert(item, at: 0)
                    completion(true)
                }
            }
        }
    }


    func fetchItems(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Keys.recordType, predicate: predicate)
        var items: [SharedItem] = []
        
        container.privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {
                completion(false)
                return
            }
            for record in records {
                if let dataString: String = record.value(forKey: Keys.recordType) as? String, let data = dataString.data(using: .ascii) {
                    do {
                        let note = try JSONDecoder().decode(SharedItem.self, from: data)
                        items.append(note)
                        if items.count == records.count {
                            self.items = items
                            completion(true)
                        }
                    } catch {
                        completion(false)
                    }
                }
            }
        }
    }
    

}

