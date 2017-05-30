//
//  VKHelper.swift
//  VKBunch
//
//  Created by Денис on 25.03.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import Foundation

import UIKit
import VK_ios_sdk
import SwiftyJSON

enum MyError: String, Error {
    case unableToParse = "unable to parse"
    case badResult = "bad result"
}

let loadedAnotherLinkNotification = Notification.Name("nameX")
let loadedMyIdNotification = Notification.Name("myId")

typealias VKLinksArray = [[Int]]

class VKHelper: NSObject {
    // My code
    
    var friendsArray = Array<Array<Friends>>()
    
    //My code
    
    static let shared = VKHelper()
    
    typealias SimpleCompletion = (Error?) -> Void
    fileprivate var completion: SimpleCompletion?
    fileprivate weak var controller: UIViewController?
    
    let SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
    
    override init() {
        super.init()
        
        VKSdk.initialize(withAppId: "5944407")
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self

    }
    
    func auth(in controller: UIViewController, completion: @escaping SimpleCompletion) {
        VKSdk.wakeUpSession(SCOPE) { (state, error) in
            if state == VKAuthorizationState.authorized {
                print("Authorized")
                completion(nil)
            }
            else{
                self.controller = controller
                self.completion = completion
                VKSdk.authorize(self.SCOPE, with: .disableSafariController)
                print("auth needed")
            }
        }
    }
    
    func loggedIn( completion: @escaping (Bool)->Void ){
        VKSdk.wakeUpSession(SCOPE) { (state, error) in
            completion(state == VKAuthorizationState.authorized)
        }
    }
    
    
    func logout() {
        VKSdk.forceLogout()
    }
    
    func setMyId(in controller: UIViewController) {
        auth(in: controller) { error in
            if error == nil {
                let request = VKApi.request(withMethod: "users.get", andParameters: nil)
                request?.execute(resultBlock: { (response) in
                    
                    let json = JSON(response?.json! as Any)
                    let myId: Int = json[0]["id"].object as? Int ?? 0
                    NotificationCenter.default.post(name: loadedMyIdNotification, object: myId)
                    
                }, errorBlock: { (error) in
                    
                })
                
            }
            
        }
    }
    
    
    func getFriends(in controller: UIViewController, count: Int, offset: Int, completion: @escaping (VKUsersArray?, Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil{
                let params = [VK_API_FIELDS : "name, nickname, photo_200_orig",
                              VK_API_OFFSET : offset,
                              VK_API_COUNT : count] as [String : Any]
                
                
                VKApi.friends().get(params).execute(resultBlock: { (result) in
                    
                    
                    guard let result = result else {
                        completion(nil, MyError.badResult)
                        return
                    }
                    
                    guard let usersArray = result.parsedModel as? VKUsersArray else {
                        completion(nil, MyError.unableToParse)
                        return
                    }
                    
                    completion(usersArray, nil)
                },
                                                    errorBlock: { error in
                                                        completion(nil, error)
                })
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    
    
    //MARK:getFriendsID
    func getFriendsID(in controller: UIViewController, count: Int, offset: Int, id: Int, completion: @escaping (VKUsersArray?, Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil{
                let params = [VK_API_FIELDS : "name, nickname, photo_200_orig",
                              VK_API_USER_ID: id,
                              VK_API_OFFSET : offset,
                              VK_API_COUNT : count] as [String : Any]
                
                
                
                VKApi.friends().get(params).execute(resultBlock: { (result) in
                    
                    
                    guard let result = result else {
                        completion(nil, MyError.badResult)
                        return
                    }
                    
                    guard let usersArray = result.parsedModel as? VKUsersArray else {
                        completion(nil, MyError.unableToParse)
                        return
                    }
                    
                    completion(usersArray, nil)
                },
                                                    errorBlock: { error in
                                                        completion(nil, error)
                })
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    //MARK:getFriendIdOutCF
    func getFriendsIdOutCF(in controller: UIViewController, id: Int, completion: @escaping (VKUsersArray?, Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil{
                let params = [VK_API_FIELDS : "name, nickname, photo_200_orig",
                              VK_API_USER_ID: id] as [String : Any]
                VKApi.friends().get(params).execute(resultBlock: { (result) in
                    guard let result = result else {
                        completion(nil, MyError.badResult)
                        return
                    }
                    
                    guard let usersArray = result.parsedModel as? VKUsersArray else {
                        completion(nil, MyError.unableToParse)
                        return
                    }
                    
                    completion(usersArray, nil)
                },
                                                    errorBlock: { error in
                                                        completion(nil, error)
                })
            } else {
                completion(nil, error)
            }
            
        }
        
    }
    //MARK:getFriendOutCF
    func getFriendsOutCF(in controller: UIViewController, completion: @escaping (VKUsersArray?, Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil{
                let params = [VK_API_FIELDS : "name, nickname, photo_200_orig"] as [String : Any]
                VKApi.friends().get(nil).execute(resultBlock: { (result) in
                    
                    guard let result = result else {
                        completion(nil, MyError.badResult)
                        return
                    }
                    
                    guard let usersArray = result.parsedModel as? VKUsersArray else {
                        completion(nil, MyError.unableToParse)
                        return
                    }
                    
                    completion(usersArray, nil)
                },
                                                    errorBlock: { error in
                                                        completion(nil, error)
                })
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getUsersInfo(in controller: UIViewController, links: [[Int]], completion: @escaping ([Int: Person]?) -> Void) {
        auth(in: controller) { error in
            if error == nil {
                var usersIdArray = [Int]()
                var usersIdStr: String = ""
                for link in 0..<links.count {
                    for idi in 0..<links[link].count{
                        if !usersIdArray.contains(links[link][idi]){
                            usersIdArray.append(links[link][idi])
                            usersIdStr = usersIdStr + String(links[link][idi]) + ","
                        }
                    }
                }
                let params = ["user_ids" : usersIdStr, "fields" : "photo_400_orig"] as [String : Any]
                let request = VKApi.request(withMethod: "users.get", andParameters: params)
                request?.execute(resultBlock: { (response) in
                    
                    let json = JSON(response?.json)
                    
                    let personFrom = json.arrayObject
                    var personDict: [Int: Person] = [:]
                    //print(personFrom)
                    //print("\n\n")
                    
                    var personOnly = Person()
                    for i in 0..<personFrom!.count {
                        
                        personOnly.firstName = json[i]["first_name"].object as? String ?? "fail_first_name"
                        personOnly.lastName = json[i]["last_name"].object as? String ?? "fail_last_name"
                        personOnly.photo = json[i]["photo_400_orig"].object as? String ?? "fail_URL"
                        personOnly.id = json[i]["id"].object as? Int ?? 0
                        //print(personOnly.firstName + String(personOnly.id) + personOnly.photo)
                        print(json[i]["id"].object as! Int)
                        
                        personDict[json[i]["id"].object as! Int] = personOnly
                        //personDict = [json[i]["id"].object as! Int : personOnly]
                        print(personDict[json[i]["id"].object as! Int]!.photo)
                    }
                    
                    print("test:" + personDict[193688362]!.photo)
                    //let personFromVk = ""
                    //print("общие друзья у \(source_uid) и \(target_uid): \(commonFriends)")
                    completion(personDict)
                }, errorBlock: { (error) in
                    
                })
                
            } else {
                print(error)
            }
            
        }
    }
    
    
    func getFriendsMutual(in controller: UIViewController, source_uid: Int, target_uid: Int, completion: @escaping ([Int], Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil {
                let params = ["source_uid" : source_uid, "target_uid" : target_uid] as [String : Any]
                let request = VKApi.request(withMethod: "friends.getMutual", andParameters: params)
                request?.execute(resultBlock: { (response) in
                    
                    let json = JSON(response?.json)
                    
                    let commonFriends: [Int] = json.arrayObject as! [Int]
                    
                    //print("общие друзья у \(source_uid) и \(target_uid): \(commonFriends)")

                    completion(commonFriends,error)
                }, errorBlock: { (error) in
                    
                })
                
            }
            
        }
        
    }
    
    func searchLinks(in controller: UIViewController, idA: Int, idB: Int) {
        
        // Грузим друзей юзера A
        self.getFriendsIdOutCF(in: controller, id: idA) { (usersArray, error) in
            
            guard error == nil else {
                print(error)
                return
            }
    
            var aFriendsIDs = [Int]()
            
            for user in usersArray!.items{
                aFriendsIDs.append((user as! VKUser).id as! Int)
            }
            
            for aFriendID in aFriendsIDs {
                self.getFriendsMutual(in: controller, source_uid: aFriendID, target_uid: idB) { (commonFriends, error) in
                    
                    if (error == nil) { // Если ошибок нет
                        
                        //print("смотрим друга \(aFriendID)")
                        
                        for mutualFriend in commonFriends {
                            let link = [idA, aFriendID, mutualFriend, idB]
                            //print("aFriendID: \(aFriendID); aFriendsIDs.last: \(aFriendsIDs.last!)")
                            
                            let notifObject: [String: Any] = ["lastFriend": aFriendID == aFriendsIDs.first! && mutualFriend == commonFriends.last!, "link": link]
                            //print(notifObject)
                            NotificationCenter.default.post(name: loadedAnotherLinkNotification, object: nil, userInfo: notifObject)
                            
                            //print("нашли цепочку \(link)")
                        }
                    }
                }
            }
            
        }
    }
    
}

extension VKHelper: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        completion?(result.error)
    }
    
    func vkSdkUserAuthorizationFailed() {
        completion?(NSError(domain:"Auth failed", code:69, userInfo:nil))
    }
    
}

extension VKHelper: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if let currentController = self.controller {
            currentController.present(controller, animated: true, completion: nil)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(captchaError)
    }
}
