import UIKit
import VK_ios_sdk

class FriendsController: UITableViewController {
    
    
    let friendsInRequests = 40
    
    var friends: [VKUser] = []
    
    override func viewDidLoad() {
        self.getFriendsFromVK()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        // Создаем ячейку, если нужно
        if cell == nil {
            cell = UITableViewCell()
        }
        
        // Если последняя ячейка, то грузим следующую порцию друзей
        if indexPath.row == friends.count - 20 {
            getFriendsFromVK()
        }

        cell?.textLabel?.text = String(indexPath.row + 1)  + ". " + friends[indexPath.row].last_name + " " + friends[indexPath.row].first_name + " id:" + String(Int(friends[indexPath.row].id))
        
        return cell!
    }
    
    //MARK: VK
    
    func getFriendsFromVK() {
        
        VKHelper.shared.getFriends(in: self, count: friendsInRequests, offset: friends.count) { (userArray, error) in
            
            // Добавляем новых друзей в список
            var newFriends: [VKUser] = []
            if let friendsArray = userArray {
                newFriends = friendsArray.items as! [VKUser]
            }
            self.friends.append(contentsOf: newFriends)
            
            self.tableView.reloadData()
        }
        
    }
}
