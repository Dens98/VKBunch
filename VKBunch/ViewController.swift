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

        VKHelper.shared.getFriendsID(in: self, count: 100, offset: 0, id: 25210402) { (usersArray, error) in
//MARK:Image
        let catPictureURL = URL(string: (usersArray?[3].photo_200_orig)!)!
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
//MARK:end Image
            }
        
            VKHelper.shared.addMyFriends(in: self)
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //комментарий тестовый
}

