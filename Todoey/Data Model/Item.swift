//
//  Item.swift
//  Todoey
//
//  Created by Pavel Andreev on 2/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
 
    
}
