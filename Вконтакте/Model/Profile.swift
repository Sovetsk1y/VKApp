//
//  Profile.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 13.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON

//В РАЗРАБОТКЕ
class Profile: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var photoNSData: NSData = NSData()
    
    convenience init(json: JSON) {
        self.init()
        
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        screenName = json["screen_name"].stringValue
        city = json["city"]["title"].stringValue
        status = json["status"].stringValue
        
    }
}
