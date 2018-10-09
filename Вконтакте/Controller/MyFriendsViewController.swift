//
//  MyFriendsViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 20.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import Realm
import RealmSwift

class MyFriendsViewController: UITableViewController {
    let vkApiService = VKApiService()
    var myFriends: Results<User>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        self.tableView.separatorStyle = .none
        vkApiService.getFriends()
        configureTableAndRealm()
        setTitle()
        self.tableView.separatorStyle = .singleLine
    }
    
    func configureTableAndRealm() {
        guard let realm = RealmDatabase.sharedInstance.realm else {
            return
        }
        
        myFriends = realm.objects(User.self)
        token = myFriends?.observe({ (changes) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        })
    }
    
    //Передаем id выбранного пользователя в FriendPhotosViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendPhotos" {
            guard let photosViewController = segue.destination as? FriendPhotosViewController,
                let indexPath = self.tableView.indexPathForSelectedRow,
                let friends = self.myFriends else { return }
            let friendsArr = Array(friends)
            photosViewController.ownerId = friendsArr[indexPath.row].vkId
            
        }
    }
    
    func setTitle() {
        guard let friends = self.myFriends else {
            return
        }
        if friends.count == 0 {
            self.navigationItem.title = "Загружаем..."
        } else {
            self.navigationItem.title = "Мои друзья"
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let friends = self.myFriends else {
            return 0
        }
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friends = self.myFriends else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myFriendsTableCell", for: indexPath) as? MyFriendsTableViewCell {
            let friend = friends[indexPath.row]
            if let image = UIImage(data: friend.photoNSData as Data) {
                cell.avatarImageView.image = image
                cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "toFriendPhotos", sender: self)
        }
}
