//
//  Item.swift
//  Todoey
//
//  Created by developer on 03/12/19.
//  Copyright © 2019 Cognizant. All rights reserved.
//
//Encodable+Decodable = Codable

import Foundation
class Item: Codable {
    var title:String = ""
    var done:Bool = false
    
}
