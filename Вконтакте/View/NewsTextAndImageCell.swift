//
//  NewsTextAndImageCell.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 15.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class NewsTextAndImageCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        }
    }
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var textOfNewsLabel: UILabel!
    @IBOutlet var imageOfNewsImageView: UIImageView!
    @IBOutlet var likesImageView: UIImageView!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var commentsImageView: UIImageView!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var repostsImageView: UIImageView!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewsImageView: UIImageView!
    @IBOutlet var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likesImageView.image = #imageLiteral(resourceName: "like")
        commentsImageView.image = #imageLiteral(resourceName: "comment")
        repostsImageView.image = #imageLiteral(resourceName: "repost")
        viewsImageView.image = #imageLiteral(resourceName: "view")
    }
}


















