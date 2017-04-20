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
//MARK:Image
        let catPictureURL = URL(string: (userArray?[3].photo_200_orig)!)!
        
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        self.myPhotoSetting?.image = UIImage(data: imageData)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        
        print("\(String(describing: userArray?[0].first_name))", "\(String(describing: userArray?[0].id))", "\(String(describing: userArray?[0].photo_200_orig))")
            }
//        VKHelper.shared.getFriends(in: self) { (error) in
//            
//            print(error)
//        }

    }
    
}

