//
//  SearchViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 03.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var idPersonA: UITextField!
    @IBOutlet weak var idPersonB: UITextField!
    @IBOutlet weak var RapSlow: UISegmentedControl!

    var links = VKLinksArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureToHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMyIdFound(notification:)), name: loadedMyIdNotification, object: nil)
                
    }
    func newMyIdFound(notification: Notification){
        let myId = notification.object as! Int
        idPersonA.text = String(myId)
        
    }
    
    @IBAction func setMyIDButton(_ sender: Any) {
        VKHelper.shared.setMyId(in: self)
    }

    
    @IBAction func searchButton(_ sender: Any) {
        //Friends.shared.addMyFriend(in: self, id: Int(idPersonA.text!)!)
//        VKHelper.shared.getFriendsMutual(in: self, source_uid: 25210402, target_uid: 4230776) { (commonFriends, error) in
//            
//        }
        
        VKHelper.shared.searchLinks(in: self, idA: Int(idPersonA.text!)!, idB: Int(idPersonB.text!)!)
        
        
        
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
}
