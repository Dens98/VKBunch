//
//  LinkResultsViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 24.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit
import Kingfisher

class LinkResultsViewController: UIViewController {

    var personData: [Int: Person] = [:]
    var links: [[Int]] = []
    var listId: [Int] = []
    var isLastFriend = Bool()
    var conteinerheight: CGFloat = 1
    var yPersonA:CGFloat = CGFloat(10)
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //вот так не работает
        //containerView.frame.width = 30
        
//        containerHeightConstraint.constant = view.frame.height * conteinerheight
//        containerWidthConstraint.constant = view.frame.width * 2
//        view.layoutIfNeeded()
        

    
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(newLinkFound(notification:)), name: loadedAnotherLinkNotification, object: nil)
        
    }
    
    func drawLinks() {
        containerHeightConstraint.constant = view.frame.height * conteinerheight
        containerWidthConstraint.constant = view.frame.width * 2
        view.layoutIfNeeded()
        var personArray1 = [UserGraphView]()
        var personArray2 = [UserGraphView]()
        
        if links[1].count >= links[2].count {
            yPersonA = CGFloat(links[1].count * 100)
        }else {
            yPersonA = CGFloat(links[2].count * 100)
        }
        
        let personA = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
        if let photoA = personData[links[0][0]]?.photo {
            personA.pic.kf.setImage(with: URL(string: photoA))
        }
        
        personA.frame = CGRect(x: 10, y: yPersonA, width: 100, height: 150)
        personData[links[0][0]]?.point = CGPoint(x: 10, y: yPersonA)
        personA.pic.layer.cornerRadius = 50
        containerView.addSubview(personA)
        
        let personB = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
        //personB.pic.kf.setImage(with: URL(string: personData[links[0][3]]!.photo))
        personB.frame = CGRect(x: 460, y: yPersonA, width: 100, height: 150)
        personData[links[0][3]]?.point = CGPoint(x: 10, y: yPersonA)
        personB.pic.layer.cornerRadius = 50
        containerView.addSubview(personB)
        
        for i1 in 0..<links[1].count {
            print(personData[links[1][i1]]!.point)
            if (personData[links[1][i1]]!.point == CGPoint(x: 0, y: 0)) {
                let person = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
                person.pic.kf.setImage(with: URL(string: personData[links[1][i1]]!.photo))
                person.frame = CGRect(x: 160, y: (i1 * 200) + 10 , width: 100, height: 150)
                personData[links[1][i1]]!.point = CGPoint(x: 160, y: (i1 * 200) + 10)
                person.pic.layer.cornerRadius = 50
                containerView.addSubview(person)
                personArray1.append(person)
            }
        }
        for i2 in 0..<links[2].count {
            if (personData[links[2][i2]]!.point == CGPoint(x: 0, y: 0)) {
                let person = UserGraphView.loadFromNibNamed(nibNamed: "UserGraphView") as! UserGraphView
                person.pic.kf.setImage(with: URL(string: personData[links[2][i2]]!.photo))
                person.frame = CGRect(x: 310, y: (i2 * 200) + 10 , width: 100, height: 150)
                personData[links[2][i2]]!.point = CGPoint(x: 310, y: (i2 * 200) + 10)
                person.pic.layer.cornerRadius = 50
                containerView.addSubview(person)
                personArray2.append(person)
            }
        }
    }
    
    func newLinkFound(notification: Notification){
        
        
        let newLink = notification.userInfo!["link"] as! [Int]
        isLastFriend = notification.userInfo!["lastFriend"] as! Bool
        print(newLink)
        print(isLastFriend)
        links.append(newLink)
        // textView.text = textView.text + "\(newLink)\n"
        
        if isLastFriend {
            if links[1].count >= links[2].count {
                
                conteinerheight = conteinerheight * (CGFloat(links[1].count) / 3 + 1 )
                
            }else {
                conteinerheight = conteinerheight * (CGFloat(links[2].count) / 3 + 1 )
            }
            VKHelper.shared.getUsersInfo(in: self, links: links) { (personDict) in
                self.personData = personDict!
                print(self.personData)
                self.drawLinks()
            }
            
            
            
            
        }else{
            
        }
        
    }
    
    func addPhotoAndNameToPerson() {
        
        
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
