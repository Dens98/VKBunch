//
//  ViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 24.03.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit
import VK_ios_sdk
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var myPhotoSetting: UIImageView?
    
    override func viewDidAppear(_ animated: Bool) {
        
            }

   
    @IBAction func ButtonSentEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() == false {
            print("Email Send Failed")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        mailViewController.setSubject("message to developer")
        
        let toRecipients = ["d89163572914@ya.ru"]
        mailViewController.setToRecipients(toRecipients)
        mailViewController.setMessageBody("Напишите здесь, что пошло не так. Отзывы приветствуются.", isHTML: false)
        self.present(mailViewController, animated: true, completion: nil)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled: print("Email Send Cancelled")
        case .saved:     print("Email Saved as a Draft")
        case .sent:      print("Email Sent Successfully")
        case .failed:    print("Email Send Failed")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ButtonLogOut(_ sender: Any) {
        VKHelper.shared.logout()
        print("logOut")
    }
    @IBAction func ButtonLogIn(_ sender: UIButton) {
       
        VKHelper.shared.getFriendsIdOutCF(in: self,  id: 25210402) { (usersArray, error) in
            let test: Int = usersArray![0].id as! Int
        print(test)
        }

               
        
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //комментарий тестовый
}

