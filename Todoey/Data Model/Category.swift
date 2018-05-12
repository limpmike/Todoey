//
//  Category.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 5/6/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
