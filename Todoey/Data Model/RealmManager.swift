//
//  RealmManager.swift
//  Todoey
//
//  Created by Pavel Andreev on 2/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    
    static let shared = RealmManager()
    
    let localRealm = try! Realm()
    


    //MARK: - Methods for Category
    func save(data: Category) {
            try! localRealm.write {
                localRealm.add(data)
            }
    }

    func delete(data: Category?) {
        guard let data = data else { return }
        try! localRealm.write {
            localRealm.delete(data)
        }
    }

    func updateCategory(category: Category?, name: String) {
        guard let category = category else { return }
        try! localRealm.write({
            category.name = name
        })
    }
    
    // MARK: - Methods for Items
    func savingItems(item: Item) {
        try! localRealm.write {
            localRealm.add(item)
        }
    }
    
    func saveItem(selectedCategory: Category, data: Item) {
        do {
            try localRealm.write {
                selectedCategory.items.append(data)
            }
        } catch {
            print("error saving item \(error)")
        }
    }
    
    func deleteItem(data: Item) {
        try! localRealm.write {
            localRealm.delete(data)
        }
    }
    
    func updateStatusItem(item: Item) {
        try! localRealm.write({
            item.done = !item.done
        })
    }
    
    func updateTitleItem(item: Item, title: String) {
        try! localRealm.write({
            item.title = title
        })
    }

}
