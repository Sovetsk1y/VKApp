//
//  Photo.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 29.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm
import RealmSwift

class Photo: Object {
    @objc dynamic var vkId: Int = 0
    @objc dynamic var imageNSData = NSData()
    @objc dynamic var url: String = ""
    
    override static func primaryKey() -> String? {
        return "vkId"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.vkId = json["id"].intValue
        if let url = json["sizes"][0]["url"].string {
            self.url = url
        }
        if let imageUrl = json["sizes"][0]["url"].url {
            if let imageData = NSData(contentsOf: imageUrl) {
                self.imageNSData = imageData
            }
        }
    }
}
