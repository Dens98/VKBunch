import UIKit
import VK_ios_sdk

class FriendsController: UITableViewController {
    
    let friendsInRequests = 40
    
    var friends: [VKUser] = [] // [НазваниеКласса] - это значит массив объектов класса 'НазваниеКласса'
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Настраиваем UI
    }
    
    //MARK: UITableViewDataSource
    // Пометки (Marks) очень классные штуки, не знаю рассказывал ли вам Гена, они помогают визуально разделить код.
    // Чтобы их увидеть, надо ткнуть в навигейшн баре в Xcode (выше этого поля) на свой контроллер
    
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
        if indexPath.row == friends.count - 1 {
            getFriendsFromVK()
        }

        // Тут уже настраиваем ячейку
        
        return cell!
    }
    
    //MARK: VK
    
    func getFriendsFromVK() {
        
        VKHelper.shared.getFriends(count: friendsInRequests, offset: friends.count, success: { vkFriendsArray in
            
            // Добавляем новых друзей в список
            var newFriends: [VKUser] = []
            if let friendsArray = vkFriendsArray {
                newFriends = friendsArray.items as! [VKUser]
            }
            self.friends.append(contentsOf: newFriends)
            
            // Затем обновляем таблицу с новыми данными
            
        }, failure: { error in
            
            // Показываем какой-нибудь алерт с ошибкой
            
        })
    }
}
