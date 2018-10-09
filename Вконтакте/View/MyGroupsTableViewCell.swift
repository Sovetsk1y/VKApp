//
//  MyGroupsTableViewCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 21.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var groupIconImageView: UIImageView! {
        didSet {
            self.groupIconImageView.layer.cornerRadius = self.groupIconImageView.frame.height / 2
        }
    }
}
