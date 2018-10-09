//
//  VKAuthService.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 26.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import Foundation
import Alamofire

class VKAuthService: VKApiService {
    
    enum URLErrors: Error {
        case wrongURL
    }
    
    init() {
        super.init(url: "https://oauth.vk.com/authorize")
    }
    
    func createAuthRequest() throws -> URLRequest {
        guard let url = URL(string: pathUrl) else {
            assertionFailure()
            throw URLErrors.wrongURL
        }
        var parameters: Parameters {
            return [
                "client_id": apiID,
                "display": "mobile",
                "redirect_uri": "https://oauth.vk.com/blank.html",
                "scope": "friends,photos,groups,wall,status",
                "response_type": "token",
                "v": apiVersion
            ]
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
