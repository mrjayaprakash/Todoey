//
//  RealmCategory.swift
//  Todoey
//
//  Created by developer on 05/12/19.
//  Copyright © 2019 Cognizant. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    
    @objc dynamic var categoryName: String = ""
    let items = List<RealmItem>() //let array = Array<Int>()
}
