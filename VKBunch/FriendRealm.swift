//
//  Friend.swift
//  VKBunch
//
//  Created by Денис on 23.04.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation
import RealmSwift

class FriendRealm: Object {
    dynamic var id = 0
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var photoUrl = ""
    dynamic var created = NSDate()
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
