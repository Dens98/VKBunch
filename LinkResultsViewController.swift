//
//  LinkResultsViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 24.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit

class LinkResultsViewController: UIViewController {

  
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //вот так не работает
       //containerView.frame.width = 30
        
        containerHeightConstraint.constant = view.frame.height
        containerWidthConstraint.constant = view.frame.width * 2
        view.layoutIfNeeded()
        
        
        
        let person = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
        person.frame = CGRect(x: 30, y: 30, width: 100, height: 150)
        person.pic.layer.cornerRadius = 50
        containerView.addSubview(person)
        
        let person2 = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
        person2.frame = CGRect(x: 170, y: 60, width: 100, height: 150)
        person2.pic.layer.cornerRadius = 50
        containerView.addSubview(person2)
        
        
        
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(newLinkFound(notification:)), name: loadedAnotherLinkNotification, object: nil)
        
    }
    
    func newLinkFound(notification: Notification){
        let newLink = notification.object as! [Int]
        
       // textView.text = textView.text + "\(newLink)\n"
        
    }
    

}


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
