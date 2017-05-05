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
    @IBAction func ButtonLogIn(_ sender: UIButton) {
       
        VKHelper.shared.getFriendsID(in: self,  id: 2343252) { (usersArray, error) in
        
        }

               
        
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //комментарий тестовый
}

