//
//  Friends.swift
//  VKBunch
//
//  Created by Артем Рябцев on 05.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation


class Friends: SearchViewController{
    var user_id = 0
    var name = ""
    var surname = ""
    var photo = ""
    
    
    func addingFriends(identificator: Any){
        self.user_id = identificator as! Int
        }
    
    func addingAdditionalInfo(name: String, surname: String, photo: String){
        self.name = name
        self.surname = surname
        self.photo = photo
    }
    
    
}
