import UIKit


struct SomeStruct {
    
    let someDict: [String : String]
    
    init(key: String, value: String) {
        self.someDict = [key : value]
    }
}
