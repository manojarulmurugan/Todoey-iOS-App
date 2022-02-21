//
//  item.swift
//  Todoey
//
//  Created by Manoj Arulmurugan on 27/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//


//MARK: - CLASS USED IF WE ARE IMPLEMENTING DataBase VIA CLASSES AND OBJECTS
/*import Foundation

class Item: Encodable, Decodable{
    var title: String = ""
    var done: Bool = false
}*/

//MARK: - Same class used for REALM DataBase

import Foundation
import RealmSwift

class ItemR: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: CategoryR.self, property: "items")
}
