//
//  MyFriendsTableViewCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 20.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        }
    }
}
