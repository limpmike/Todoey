//
//  Item.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 5/6/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
