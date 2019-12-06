//
//  RealmItem.swift
//  Todoey
//
//  Created by developer on 05/12/19.
//  Copyright © 2019 Cognizant. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: RealmCategory.self, property: "items")// the name of inverse relationship in Realmcategrory list
}

