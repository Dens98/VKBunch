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
    
    struct Friend {
        var id: Int?
        var firstName: String?
        var lastName: String?
        var photo200: String?
    }
    var friendArray = [[Friend]]()
    
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
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        appDelegate?.window?.rootViewController
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
        //        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //        appDelegate?.window?.rootViewController
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
        //        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //        appDelegate?.window?.rootViewController
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
        //        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //        appDelegate?.window?.rootViewController
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
    
    
    func addMyFriend() {
        getFriendsOutCF(in: controller!) { (usersArray, error) in
//            for i in 0..<Int((usersArray?.count)!) {
//                                self.friendArray[0][i].id = (usersArray?[UInt(i)].id as! Int)
//                                self.friendArray[0][i].firstName = usersArray?[UInt(i)].first_name
//                                self.friendArray[0][i].lastName = usersArray?[UInt(i)].last_name
//                                self.friendArray[0][i].photo200 = usersArray?[UInt(i)].photo_200_orig
//                                print(String(i + 1) + self.friendArray[0][i].lastName! + self.friendArray[0][i].firstName!)
//                            }
            
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
