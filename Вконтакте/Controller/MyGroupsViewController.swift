//
//  MyGroupsViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 21.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import RealmSwift

let COUNT_OF_LOADING_DATA = 30

class MyGroupsViewController: UITableViewController {

    let vkApiService = VKApiService()
    var myGroups: Results<Group>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        self.tableView.separatorStyle = .none
        vkApiService.getGroups()
        configureTableAndRealm()
        setTitle()
        self.tableView.separatorStyle = .singleLine
    }
    
    func setTitle() {
        guard let groups = self.myGroups else {
            return
        }
        if groups.count == 0 {
            self.navigationItem.title = "Загружаем..."
        } else {
            self.navigationItem.title = "Мои группы"
        }
    }
    
    func configureTableAndRealm() {
        guard let realm = RealmDatabase.sharedInstance.realm else {
            return
        }
        myGroups = realm.objects(Group.self)
        token = myGroups?.observe({ (changes) in
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
    
    // MARK: - Table view data source

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toGroupSearch", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groups = self.myGroups else {
            return 0
        }
        return groups.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let groups = self.myGroups else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsTableViewCell", for: indexPath) as? MyGroupsTableViewCell {
            let group = groups[indexPath.row]
            if let image = UIImage(data: group.imageNSData as Data) {
                cell.groupIconImageView.image = image
                cell.groupNameLabel.text = group.name
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
