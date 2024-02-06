//
//  UserModel.swift
//  Plin
//
//  Created by Be Ready Software on 28/07/21.
//

import Foundation

class UserModel: Codable{
    internal init(id: Int? = nil, nome: String? = nil, imgUrl: String? = nil, cognome: String? = nil, email: String? = nil, corsoStudi: String? = nil, isUniurbUser: Bool? = nil) {
        self.id = id
        self.nome = nome
        self.imgUrl = imgUrl
        self.cognome = cognome
        self.email = email
        self.corsoStudi = corsoStudi
        self.isUniurbUser = isUniurbUser
    }
    
    var id: Int?
    var nome: String?
    var imgUrl: String?

    var cognome: String?
    var email: String?
    var corsoStudi: String?
    var isUniurbUser: Bool?

}

class UserModelRequest: Codable{
    internal init(nome: String? = nil, cognome: String? = nil, email: String? = nil, pushId: String? = nil, os: String = "ios") {
        self.nome = nome
        self.cognome = cognome
        self.email = email
        self.pushId = pushId
        self.os = os
    }
    
    var nome: String?
    var cognome: String?
    var email: String?
    var pushId: String?
    var os: String = "ios"

}

struct UserModelResponse: Codable{
    var status, message: String?
    var data: UserModel?
}
