//
//  Friends.swift
//  VKBunch
//
//  Created by Артем Рябцев on 05.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation


struct friendStruct {
    var id = 0
    var firstName = ""
    var lastName = ""
    var photo = ""
}

class Friends: SearchViewController {
    static let shared = Friends()
    
    
    
    var friendsArray = [[friendStruct]]()
    
    func addMyFriend(in controller: SearchViewController, id: Int) {
        VKHelper.shared.getFriendsIdOutCF(in: self,  id: id) { (usersArray, error) in
            
            var friendTemp = [friendStruct]()
                        var friend = friendStruct()
                        for i in 0..<Int((usersArray?.count)!) {
                            friend.id = (usersArray?[UInt(i)].id as! Int)
                            friend.firstName = (usersArray?[UInt(i)].first_name)!
                            friend.lastName = (usersArray?[UInt(i)].last_name)!
                            friend.photo = (usersArray?[UInt(i)].photo_200_orig)!
                            friendTemp.append(friend)
                            print(String(friendTemp[i].id))
                            
                        }
                        self.friendsArray.append(friendTemp)
            for i in 0..<friendTemp.count {
                print(String(friendTemp[i].id) + friendTemp[i].lastName)
            }
            
        }
//        print(self.friendsArray[0][0].firstName + self.friendsArray[0][0].lastName)
//        for j in 0..<Int(friendsArray[0].count) {
//            print(String(Int(friendsArray[0].count)) + friendsArray[0][j].firstName + " " + friendsArray[0][j].lastName)
//        }
        
    }
    
    
    
}
