//
//  GroupSearchViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 21.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GroupSearchViewController: UITableViewController {
    
    let vkApiService = VKApiService()
    var filteredGroups = [Group]()
    private var groups = [Group]()

    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Поиск групп"
        filteredGroups = groups
        
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredGroups.count == 0 {
            return 0
        } else {
            return self.filteredGroups.count + 1
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row + 1) > self.filteredGroups.count {
            return 44
        } else {
            return 70
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row + 1) > self.filteredGroups.count {
            let cell = UITableViewCell()
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Показать ещё 30"
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "allGroupsTableViewCell", for: indexPath) as? GroupSearchTableViewCell {
            let group = self.filteredGroups[indexPath.row]
            if let image = UIImage(data: group.imageNSData as Data) {
                cell.iconImageView.image = image
                cell.groupNameLabel.text = group.name
                cell.numberOfSubsLabel.text = "\(group.membersCount) участников"
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = UserDataKeyChain.getUserID() else { return }
        let group = self.filteredGroups[indexPath.row]
        vkApiService.joinGroup(groupId: group.vkId)
        //Добавляем добавленную группу к соответствующему пользователью в Firebase Database
        let dbLink = Database.database().reference()
        dbLink.child("Users/\(userId)/groups/\(group.vkId)").setValue(group.name)
        
        RealmDatabase.sharedInstance.saveData(data: [group], type: Group.self)
        self.filteredGroups.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
}

extension GroupSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.hideKeyboard()
        guard let searchText = searchBar.text else {
            return
        }
        if searchText.isEmpty {
            filteredGroups = groups
        } else {
            vkApiService.getSearchedGroups(searchingText: searchText, offset: 0, completion: { (groups) in
                self.filteredGroups = groups
                DispatchQueue.main.async {
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                }
            })
        }
    }
}
