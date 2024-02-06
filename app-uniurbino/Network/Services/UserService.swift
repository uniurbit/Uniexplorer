//
//  UserService.swift
//  Plin
//
//  Created by Manuela on 26/07/21.
//

import Alamofire
import Reachability
import Foundation

class UserService {
    
    static func postLogin(userRequest: UserModelRequest, completion: @escaping (UserModel)->Void, completionError: @escaping (ApiError)->Void) {
        APIClient.performRequest(route: APIRouter.login(userRequest: userRequest.objtoJsonString()),
                                 completion: { (result:UserModelResponse) in
            print(result.toJsonString())
            
            
            if
                let data = result.data,
                let domain = data.email?.substringAfterLastOccurenceOf("@")
            {
                if domain.contains("uniurb"){
                    data.isUniurbUser = true
                } else {
                    data.isUniurbUser = false
                }
                if let user = UserSettingsManager.sharedInstance.getSavedUser(){
                    let userToSave = data
                    userToSave.imgUrl = user.imgUrl
                    UserSettingsManager.sharedInstance.saveUser(user: userToSave)

                }else{
                    UserSettingsManager.sharedInstance.saveUser(user: data)
                }
                completion(data)
            }else{
                completionError(ApiError(.ServerError, errorMessage: result.message))
            }
        },
                                 completionError: { error in
            completionError(error)
        })
    }
    
    static func logout(completion: @escaping (ApiSucces)->Void, completionError: @escaping (ApiError)->Void) {
        APIClient.performRequest(route: APIRouter.logout,
                                 completion: { (result:ApiSucces) in
            UserSettingsManager.sharedInstance.saveUser(user: nil)
            completion(result)
        },completionError: { error in
            completionError(error)
        })
    }
    
    static func getCalendar(completion: @escaping ([EventoModel])->Void, completionError: @escaping (ApiError)->Void) {
        APIClient.performRequest(route: APIRouter.getCalendar,
                                 completion: { (result:EventoModelResponse) in
            UserSettingsManager.sharedInstance.saveCalendar(calendar: result.data)
            if let data = result.data{
                completion(data)
            }else{
                completionError(ApiError(.ServerError, errorMessage: result.message))
            }
            
        },completionError: { error in
            completionError(error)
        })
    }
}

extension String {
    
    var nsRange: NSRange {
        return Foundation.NSRange(startIndex ..< endIndex, in: self)
    }
    
    subscript(nsRange: NSRange) -> Substring? {
        return Range(nsRange, in: self)
            .flatMap { self[$0] }
    }
    
    func substringAfterLastOccurenceOf(_ char: Character) -> String {
        
        let regex = try! NSRegularExpression(pattern: "\(char)\\s*(\\S[^\(char)]*)$")
        if let match = regex.firstMatch(in: self, range: self.nsRange), let result = self[match.range(at: 1)] {
            return String(result)
        }
        return ""
    }
}
