//
//  DialogCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 17.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {

    @IBOutlet var dialogImageView: UIImageView! {
        didSet {
            dialogImageView.layer.cornerRadius = dialogImageView.frame.height / 2
        }
    }
    @IBOutlet var addresseeNameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    
}
