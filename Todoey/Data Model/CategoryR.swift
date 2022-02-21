//
//  Category.swift
//  Todoey
//
//  Created by Manoj Arulmurugan on 24/03/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryR: Object {
    @objc dynamic var name: String = ""
    let items = List<ItemR>()
}
