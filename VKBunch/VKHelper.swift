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

enum MyError: String, Error {
    case unableToParse = "unable to parse"
    case badResult = "bad result"
}


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
    
    
    
    
    //MARK:getFriendIdOutCF
    func getFriendsID(in controller: UIViewController, id: Int, completion: @escaping (VKUsersArray?, Error?) -> Void) {
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
    func getFriends(in controller: UIViewController, completion: @escaping (VKUsersArray?, Error?) -> Void) {
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
    
    
//    func addMyFriends(in controller: UIViewController) {
//        getFriendsOutCF(in: controller) { (usersArray, error) in
//// Int((usersArray?.count)!)
////            for i in 0..<Int((usersArray?.count)!) {
////                var friend = Friends()
////                friend.id = (usersArray?[UInt(i)].id as! Int)
////                friend.firstName = usersArray?[UInt(i)].first_name
////                friend.lastName = usersArray?[UInt(i)].last_name
////                friend.photo200 = usersArray?[UInt(i)].photo_200_orig
////                self.friendArray.append([friend])
////                print(String(i + 1) + ". " + self.friendArray[i].firstName! + " " + self.friendArray[i].lastName! + " " + String(Int((usersArray?.count)!)))
////            }
//            
//            
//            var friendTemp = Array<Friends>()
//            var friend = Friends()
//            for i in 0..<Int((usersArray?.count)!) {
//                friend.id = (usersArray?[UInt(i)].id as! Int)
//                friend.firstName = usersArray?[UInt(i)].first_name
//                friend.lastName = usersArray?[UInt(i)].last_name
//                friend.photo200 = usersArray?[UInt(i)].photo_200_orig
//                friendTemp.append(friend)
//            }
//            self.friendsArray.append(friendTemp)
//            print(self.friendsArray[0][55].firstName! + self.friendsArray[0][55].lastName!)
//        }
//    }
//    func addFriends(){
//        
//    }
}
//

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
