//
//  Item.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/13/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Each item has a parent category that has items stored in the Category's items property
}
