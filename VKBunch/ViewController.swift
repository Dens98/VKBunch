//
//  ViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 24.03.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController {
    @IBOutlet weak var myPhotoSetting: UIImageView?
    override func viewDidAppear(_ animated: Bool) {
        
            }
    
    @IBAction func ButtonLogOut(_ sender: Any) {
        VKHelper.shared.logout()
        print("logOut")
    }
    let qwer: Bool = true
    @IBAction func ButtonLogIn(_ sender: UIButton) {

       VKHelper.shared.getFriends(in: self, count: 100, offset: 0) { (userArray, error) in
            
            
            print("\(String(describing: userArray?[0].first_name))", "\(String(describing: userArray?[0].id))")
            }
//        VKHelper.shared.getFriends(in: self) { (error) in
//            
//            print(error)
//        }

    }
    
}

