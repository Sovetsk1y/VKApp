//
//  UserDataKeyChain.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 27.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class UserDataKeyChain {
    
    static func saveData(token: String, user_id: Int) {
        KeychainWrapper.standard.set(token, forKey: "token")
        KeychainWrapper.standard.set(user_id, forKey: "user_id")
    }
    
    static func getToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "token")
    }
    
    static func getUserID() -> Int? {
        return KeychainWrapper.standard.integer(forKey: "user_id")
    }
}
