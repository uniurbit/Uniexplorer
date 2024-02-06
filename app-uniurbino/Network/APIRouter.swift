//
//  APIRouter.swift
//  myMerenda
//
//  Created by Manuela on 13/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    case login(userRequest: String)
    case logout
    case getAll
    case getPreferiti(idUtente: String)
    case addLuogo(idUtente: String, uuid: String, major: Int, minor: Int)
    case getLuogo(uuid: String, major: String, minor: String)
    case deleteLuogo(idUtente: String, uuid: String, major: Int, minor: Int)
    case getCalendar

    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .logout:
            return .post
        case .getAll, .getPreferiti, .getLuogo, .getCalendar:
            return .get
        case .addLuogo:
            return .post
        case .deleteLuogo:
            return .delete
        }
    }
    
    // MARK: - Path
    // Parte finale del path dell'API
    private var path: String {
        switch self {
        case .login:
            return "accounts/login"
        case .logout:
            return "accounts/logout"
        case .getAll:
            return "beacons"
        case .getPreferiti(let idUtente):
            return "account/\(idUtente)/bookmarks"
        case .addLuogo(let idUtente, _, _, _):
            return "account/\(idUtente)/bookmarks"
        case .getLuogo(let uuid, let major, let minor):
            return "beacons/\(uuid)/\(major)/\(minor)"
        case .deleteLuogo(let idUtente, _, _, _):
            return "account/\(idUtente)/bookmarks"
        case .getCalendar:
            guard let idUtente = UserSettingsManager.sharedInstance.getSavedUser()?.id else {return ""}
            return "account/\(idUtente)/events"
        }
    }
    
    // MARK: - Parameters for http body
    private var parameters: Parameters? {
        switch self {
        case .logout:
            guard
                let userID = UserSettingsManager.sharedInstance.getSavedUser()?.id,
                let pushIdentifier = UserSettingsManager.sharedInstance.pushIdentifierString
            else { return nil }
            return ["idUtente": userID, "pushId": pushIdentifier]
        case .addLuogo(_, let uuid, let major, let minor):
            return ["uuid": uuid, "major": major, "minor": minor]
        case .deleteLuogo(_, let uuid, let major, let minor):
            return ["uuid": uuid, "major": major, "minor": minor]
        default:
            return nil
        }
    }
    
    // MARK: - Parameters for http body
    private var parametersString: String? {
        switch self {
        case .login(let userRequest):
            return userRequest
        default:
            return nil
        }
    }
    
    // MARK: - URLParameters for url query
    private var urlparameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - header parameters for url query
    private var headerparameters: Parameters? {
        return nil
    }
    
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        //let auth = "\(ContentType.authorization.rawValue) \(SharedUtils.GlobalVar.access_token)"
        var url: URL
        
        if let queryParams = urlparameters {
            //Url query params
            let urlString = APIUtils.Server.baseURL + path
            var urlComponents = URLComponents(string: urlString)!
            
            var queryItems = [URLQueryItem]()
            for (key,value) in queryParams {
                if let v = value as? Int{
                    queryItems.append(URLQueryItem(name: key, value: String(v)))
                }else{
                    queryItems.append(URLQueryItem(name: key, value: (value as! String)))
                    
                }
            }
            urlComponents.queryItems = queryItems
            url = urlComponents.url!
        }
        else {
            url = try APIUtils.Server.baseURL.asURL()
            url = url.appendingPathComponent(path)
        }
        
        var urlRequest = URLRequest(url: url)
        print("\(String(describing: urlRequest.url!))")
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let headerParam = headerparameters {
            for par in headerParam {
                if par.key != "Authorization" {
                    urlRequest.setValue(par.value as? String, forHTTPHeaderField: par.key)
                }
            }
        }
        switch APIUtils.Server.authorizationType {
        case .basic:
            let auth = APIRouter.getAuthenticationString()
            urlRequest.setValue("Basic \(auth)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        case .token:
            urlRequest.setValue("Token \(APIUtils.Server.authorizationValue)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        case .bearer:
            urlRequest.setValue("Bearer \(APIUtils.Server.authorizationValue)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        case .none:
            print("no auth")
        }
        
        print(urlRequest.allHTTPHeaderFields!)
        
        // Parameters
        if let parameters = parameters {
            print(parameters)
            do {
                // se la tipologia del body è json
                let requestType = HTTPHeaderField.contentType.rawValue
                if urlRequest.value(forHTTPHeaderField:requestType) == ContentType.json.rawValue {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
                // altrimenti se è x-www-form-urlencoded
                else {
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        else if let parametersString = parametersString {
            print(parametersString)
            urlRequest.httpBody = parametersString.data(using: .utf8)
        }
        
        return urlRequest
    }
    
    
    static func getAuthenticationString() -> String {
        let username = APIUtils.Server.USERNAME
        let password = APIUtils.Server.PASSWORD
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let authString = loginData.base64EncodedString()
        return authString
    }
}
