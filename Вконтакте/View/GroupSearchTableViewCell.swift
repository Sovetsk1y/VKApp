//
//  GroupSearchTableViewCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 21.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class GroupSearchTableViewCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            self.iconImageView.layer.cornerRadius = self.iconImageView.frame.height / 2
        }
    }
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var numberOfSubsLabel: UILabel!
}
