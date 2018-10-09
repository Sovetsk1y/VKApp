//
//  Group.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 21.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Realm

class Group: Object {
    
    @objc dynamic var vkId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var membersCount = 0
    @objc dynamic var isClosed = false
    @objc dynamic var isMember = false
    @objc dynamic var imageNSData = NSData()
    
    override static func primaryKey() -> String? {
        return "vkId"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.vkId = json["id"].intValue
        self.name = json["name"].stringValue
        self.membersCount = json["members_count"].intValue
        if json["is_closed"].intValue == 1 {
            self.isClosed = true
        } else {
            self.isClosed = false
        }
        if json["is_member"].intValue == 1 {
            self.isMember = true
        } else {
            self.isMember = false
        }
        if let imageUrl = json["photo_200"].url {
            if let imageData = NSData(contentsOf: imageUrl) {
                self.imageNSData = imageData
            }
        }
    }
}
