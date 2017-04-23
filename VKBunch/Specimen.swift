//
//  Specimen.swift
//  VKBunch
//
//  Created by Denis Shustin on 22.04.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation
import RealmSwift

class Specimen: Object {
    dynamic var id = 0
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var photo200Url = ""
    dynamic var created = NSDate()
}
