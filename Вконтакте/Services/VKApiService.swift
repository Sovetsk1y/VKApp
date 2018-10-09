//
//  VKApiService.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 25.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import RealmSwift

class VKApiService {
    var apiID = "6643071"
    var pathUrl: String
    var apiVersion = "5.80"
    var startFrom: String = "0"
    
    convenience init() {
        self.init(url: "https://api.vk.com/method")
    }
    
    init(url: String) {
        pathUrl = url
    }
    
    func createRequestAndGetResponse(_ parameters: Parameters, _ method: String, completion: @escaping (JSON) -> Void) {
        guard let url = URL(string: pathUrl) else {
            return
        }
        Alamofire.request(url.appendingPathComponent(method), method: .get, parameters: parameters).responseSwiftyJSON(queue: .global(qos: .userInitiated)) { (response) in
            guard let json = response.value else {
                return
            }
            completion(json)
        }
    }
    
    func getFriends() {
        guard let user_id = UserDataKeyChain.getUserID(), let accessToken = UserDataKeyChain.getToken() else {
            print("Ошибка при получении id, token")
            return
        }
        var parameters: Parameters {
            return [
                "user_id": user_id,
                "access_token": accessToken,
                "order": "name",
                "offset": 0,
                "fields": "photo_200,city",
                "v": apiVersion
            ]
        }
        
        createRequestAndGetResponse(parameters, "friends.get") { (json) in
            let users = json["response"]["items"].map({User.init(json: $0.1)})
            RealmDatabase.sharedInstance.saveData(data: users, type: User.self)
        }
    }
    
    func getGroups() {
        guard let user_id = UserDataKeyChain.getUserID(), let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            return [
                "user_id": user_id,
                "access_token": accessToken,
                "extended": 1,
                "offset": 0,
                "fields": "members_count",
                "v": apiVersion
            ]
        }
        
        createRequestAndGetResponse(parameters, "groups.get") { (json) in
            let groups = json["response"]["items"].map({Group.init(json: $0.1)})
            RealmDatabase.sharedInstance.saveData(data: groups, type: Group.self)
        }
    }
    
    func joinGroup(groupId: Int) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            return [
                "access_token": accessToken,
                "group_id": groupId,
                "v": apiVersion
            ]
        }
        createRequestAndGetResponse(parameters, "groups.join") { (json) in
            let response = json["response"].intValue
            if response == 1 {
                print("Join completed")
            } else {
                print("Error")
            }
        }
    }
    
    func getGroupById(groupId: Int, completion: @escaping(Group) -> Void) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            return [
                "access_token": accessToken,
                "group_id": groupId,
                "fields": "members_count",
                "v": apiVersion
            ]
        }
        
        createRequestAndGetResponse(parameters, "groups.getById") { (json) in
            let group = Group(json: json["response"][0])
            completion(group)
        }
    }
    
    func getSearchedGroups(searchingText: String, offset: Int, completion: @escaping ([Group]) -> Void) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            return [
                "access_token": accessToken,
                "q": searchingText,
                "type": "group",
                "fields": "members_count",
                "sort": 0,
                "count": 30,
                "offset": offset,
                "v": apiVersion
            ]
        }
        
        createRequestAndGetResponse(parameters, "groups.search") { (json) in
            let groups = json["response"]["items"].map({Group.init(json: $0.1)})
            completion(groups)
        }
    }
    
    func getUserPhotos(ownerId: Int?, completion: @escaping ([Photo]) -> Void) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            if let id = ownerId {
                return [
                    "access_token": accessToken,
                    "user_id": id,
                    "album_id": "profile",
                    "rev": 1,
                    "extended": 0,
                    "v": apiVersion
                ]
            } else {
                return [
                    "access_token": accessToken,
                    "album_id": "profile",
                    "rev": 1,
                    "extended": 0,
                    "v": apiVersion
                ]
            }
            
        }
        
        createRequestAndGetResponse(parameters, "photos.get") { (json) in
            let photos = json["response"]["items"].map({Photo.init(json: $0.1)})
            completion(photos)
        }
    }
    
    func getNews(completion: @escaping([News]) -> Void) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            return [
                "access_token": accessToken,
                "filters": "post",
                "count": 20,
                "start_from": startFrom,
                "v": "5.80"
            ]
        }
        
        createRequestAndGetResponse(parameters, "newsfeed.get") { (json) in
            self.startFrom = json["response"]["next_from"].stringValue
            let news = json["response"]["items"].map({News.init(json: $0.1)})
            completion(news)
        }
    }
    
    func getUser(userId: Int?, completion: @escaping (User) -> Void) {
        guard let accessToken = UserDataKeyChain.getToken() else {
            return
        }
        
        var parameters: Parameters {
            if let id = userId {
                return [
                    "access_token": accessToken,
                    "user_ids": id,
                    "fields": "photo_200,city,online",
                    "v": apiVersion
                ]
            } else {
                return [
                    "access_token": accessToken,
                    "fields": "photo_200,city,online",
                    "v": apiVersion
                ]
            }
        }
        
        createRequestAndGetResponse(parameters, "users.get") { (json) in
            let user = User(json: json["response"][0])
            completion(user)
        }
    }
}
