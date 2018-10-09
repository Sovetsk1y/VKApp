//
//  User.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 28.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm
import RealmSwift

class City: Object {
    @objc dynamic var vkId: Int = 0
    @objc dynamic var title: String = ""
    
    convenience init(json: JSON) {
        self.init()
        self.vkId = json["id"].intValue
        self.title = json["title"].stringValue
    }
}

class User: Object {
    
    @objc dynamic var vkId: Int = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var city: City?
    @objc dynamic var isOnline = false
    @objc dynamic var photoNSData = NSData()
    
    override static func primaryKey() -> String? {
        return "vkId"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.vkId = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.city = City(json: json["city"])
        if json["online"].intValue == 1 {
            self.isOnline = true
        } else {
            self.isOnline = false
        }
        if let photoUrl = json["photo_200"].url {
            if let photoData = NSData(contentsOf: photoUrl) {
                self.photoNSData = photoData
            }
        }
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
