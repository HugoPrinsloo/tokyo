//
//  SharedFile.swift
//  Tokyo
//
//  Created by Hugo Prinsloo on 2018/10/14.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation

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
    
}

class Fetcher {
    func fetch() -> SharedFile {
        return Image()
    }
    
}
