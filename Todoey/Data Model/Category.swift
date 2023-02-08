//
//  Category.swift
//  Todoey
//
//  Created by Pavel Andreev on 2/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var items = List<Item>()
    
    
}
