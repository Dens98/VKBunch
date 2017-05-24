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

typealias VKLinksArray = [[Int]]

class VKHelper: NSObject {
    // My code
    
    var friendsArray = Array<Array<Friends>>()
    var myID: Int = 0
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
    
    func getFriendsMutual(in controller: UIViewController, source_uid: Int, target_uid: Int, completion: @escaping ([Int], Error?) -> Void) {
        auth(in: controller) { error in
            if error == nil {
                let params = ["source_uid" : source_uid, "target_uid" : target_uid] as [String : Any]
                let request = VKApi.request(withMethod: "friends.getMutual", andParameters: params)
                request?.execute(resultBlock: { (response) in
                    
                    let json = JSON(response?.json)
                    print(json ?? nil)
                    let commonFriends: [Int] = json.arrayObject as! [Int]
                    print(commonFriends)
                    
                    //print(response ?? "Empty")

                    completion(commonFriends,error)
                }, errorBlock: { (error) in
                    
                })
                
            }
            
        }
        
    }
    
    func searchLinks(in controller: UIViewController, idA: Int, idB: Int, completion: @escaping (VKLinksArray?, Error?) -> Void) {
        
        var links: VKLinksArray = [];
        
        // Грузим друзей юзера A
        self.getFriendsIdOutCF(in: controller, id: idA) { (usersArray, error) in
            
            
            if (error == nil) { // Если ошибок нет
                
                for friend in 0..<Int((usersArray?.count)!) {
                    
                    
                    // Для каждого друга грузим список его общих друзей с юзером B
                    print(usersArray![UInt(friend)].id as! Int)
                    self.getFriendsMutual(in: controller, source_uid: usersArray![UInt(friend)].id as! Int, target_uid: idB) { (commonFriends, error) in
                        
                        if (error == nil) { // Если ошибок нет
                            
                            for i in commonFriends {
                                print("test Array")
                                print(usersArray![UInt(friend)].id as! Int)
                                let link = [idA, usersArray![UInt(friend)].id as! Int, commonFriends[i], idB]
                                links.append(link as! [Int])
                                
                            }
                            
                            if (UInt(friend) == usersArray?.count) {
                                completion(links, error)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension VKHelper: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
//        myID = result.user.id.intValue
//        print(String(result.user.id.intValue))
        let x = result.user
        print(result.state)
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
