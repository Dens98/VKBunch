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
    override func viewDidAppear(_ animated: Bool) {
        
            }
    
    @IBAction func ButtonLogIn(_ sender: UIButton) {
        VKHelper.shared.getFriends(in: self) { (userArray) in
            print("\(userArray[0].first_name)")
            
        }
        
        VKHelper.shared.getFriends(in: self) { (error) in
            
            //       print(error)
        }

        
        //print("Hi")
    }
    
}

