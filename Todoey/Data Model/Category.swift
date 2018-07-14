//
//  Category.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/13/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // Each category has a list of items
}
