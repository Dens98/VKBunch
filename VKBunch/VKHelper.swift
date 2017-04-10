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
    // sent to ViewCntr array but no error
    
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
                completion(nil)
            }
            else{
                self.controller = controller
                self.completion = completion
                VKSdk.authorize(self.SCOPE, with: .disableSafariController)
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
    
    
    //func getFriends(in controller: UIViewController, completion: @escaping SimpleCompletion) {

//        auth(in: controller) { error in
//            if error == nil{
//                VKApi.friends().get([VK_API_FIELDS : "name, nickname, photo_200_orig"]).execute(resultBlock: { (result) in
//                    if let result = result {
//                        if let usersArray = result.parsedModel as? VKUsersArray {
//                            
//                            for i in 0..<usersArray.count {
//                                if let user = usersArray[i]
//                                {
//                                    print("\(user.first_name) \(user.last_name) \(user.screen_name)\n")
//                                    
//                                }
//                            }
//                            print("у меня \(usersArray.count) друзей")
//                            
//                            completion(usersArray)
//                            //completion(nil)
//                        }                    }
//                }, errorBlock: { error in completion(error) })
//            } else{ completion(error) }
//        }
//        
//    }
    
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
