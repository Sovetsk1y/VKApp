//
//  RealmDatabase.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 07.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDatabase {
    static let sharedInstance = RealmDatabase()
    var realm: Realm? {
        do {
            let r = try Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
            return r
        } catch {
            print(error)
        }
        return nil
    }
    
    func saveData(data: [Object], type: Object.Type) {
        DispatchQueue.main.async {
            if let realm = self.realm {
                do {
                    realm.beginWrite()
                    realm.add(data, update: true)
                    try realm.commitWrite()
                } catch {
                    print(error)
                }
            }
        }
    }
}
