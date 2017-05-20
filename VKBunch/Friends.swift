//
//  Friends.swift
//  VKBunch
//
//  Created by Артем Рябцев on 05.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation


struct FriendStruct {
    var id = 0
    var firstName = ""
    var lastName = ""
    var photo = ""
}

class Friends: SearchViewController {
    static let shared = Friends()
    
    
    
    
    var friendTemp = [FriendStruct]()
    
    
    func addMyFriend(in controller: SearchViewController, id: Int) {
        VKHelper.shared.getFriendsIdOutCF(in: self,  id: id) { (usersArray, error) in
            
            
                        var friend = FriendStruct()
                        for i in 0..<Int((usersArray?.count)!) {
                            friend.id = (usersArray?[UInt(i)].id as! Int)
                            friend.firstName = (usersArray?[UInt(i)].first_name)!
                            friend.lastName = (usersArray?[UInt(i)].last_name)!
                            friend.photo = (usersArray?[UInt(i)].photo_200_orig)!
                            self.friendTemp.append(friend)
                            print(String())
                            
                        }
            
            for i in 0..<self.friendTemp.count {
                print(String(self.friendTemp[i].id) + self.friendTemp[i].lastName)
            }
            print(self.friendTemp.count)
        }

        
    }
    
    
    
}
