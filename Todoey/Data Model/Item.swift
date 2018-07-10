//
//  Item.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/9/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation

class Item : NSObject, NSCoding {
    var title : String = ""
    var done : Bool = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(done, forKey: "done")
        aCoder.encode(title, forKey: "title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        done = aDecoder.decodeObject(forKey: "done") as? Bool ?? aDecoder.decodeBool(forKey: "done")
        title = aDecoder.decodeObject(forKey: "title") as! String
    }
    
    override init() {
        super.init()
    }
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
    init(title: String) {
        self.title = title
    }
}
