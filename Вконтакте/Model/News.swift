//
//  News.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 31.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import SwiftyJSON

//В стадии разработки
class News {
    var authorName:String = ""
    var authorImage = UIImage()
    var postText: String = ""
    var postImage = UIImage()
    var likes: Int
    var reposts: Int
    var comments: Int
    var views: Int
    
    init(json: JSON) {
        
        let vkApi = VKApiService()
        self.postText = json["text"].stringValue
        let photoUrl = json["attachments"][0]["photo"]["sizes"][2]["url"].url
        if let url = photoUrl {
            let photoNSData = NSData(contentsOf: url)
            if let nsData = photoNSData {
                if let image = UIImage(data: nsData as Data) {
                    self.postImage = image
                }
            }
        }
        self.likes = json["likes"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        let sourceId = json["source_id"].intValue
        if sourceId < 0 {
            vkApi.getGroupById(groupId: abs(sourceId), completion: {(group) in
                print(group.name)
                self.authorName = group.name
                if let image = UIImage(data: group.imageNSData as Data) {
                    self.authorImage = image
                }
            })
        } else {
            vkApi.getUser(userId: sourceId, completion: {(user) in
                print(user.lastName)
                self.authorName = "\(user.firstName) \(user.lastName)"
                if let image = UIImage(data: user.photoNSData as Data) {
                    self.authorImage = image
                }
            })
        }
        
    }
}
