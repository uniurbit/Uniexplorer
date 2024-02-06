//
//  APIConstants.swift
//  myMerenda
//
//  Created by Manuela on 13/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Foundation

struct APIUtils {
    struct Server {
        
        static let URL = ""
        
        static let ONESIGNAL_KEY = ""

        static var baseURL = URL + "/api/v1/"
        static var authorizationType: AuthorizationType = .bearer
        static var authorizationValue: String = ""
        
//        compilare per authorization basic
        static let USERNAME = ""
        static let PASSWORD = ""

        
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case youtubeIos = "X-Ios-Bundle-Identifier"
}

enum AuthorizationType {
    case none
    case token
    case basic
    case bearer
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}

