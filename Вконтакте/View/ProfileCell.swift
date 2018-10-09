//
//  ProfileCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 02.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileCell: UITableViewCell {
    
    @IBOutlet var profileIcon: UIImageView! {
        didSet{
            profileIcon.layer.cornerRadius = profileIcon.frame.height / 2
            let vkApiService = VKApiService()
            vkApiService.getUser(userId: nil) { (user) in
                DispatchQueue.main.async {
                    self.profileLabel.text = user.getFullName()
                    if let image = UIImage(data: user.photoNSData as Data) {
                        self.profileIcon.image = image
                    }
                }
            }
        }
    }
    @IBOutlet var profileLabel: UILabel!
}
