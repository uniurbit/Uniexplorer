//
//  FavouriteModel.swift
//  app-uniurbino
//
//  Created by Lorenzo on 06/02/23.
//

import Foundation

struct FavouriteModel: Codable{
    var nomeEdificio: String?
    var nomeStanza: String?
    var uuid: String?
    var majorNumber: Int?
    var minorNumber: Int?
    var idStanza: String?
}

struct LuogoDetails: Codable {
    var idStanza, idEdificio, uuid: String?
    var majorNumber: Int?
    var minorNumber: Int?
    var nomeStanza, testo, nomeEdificio: String?
}

struct FavouriteModelResponse: Codable{
    var status, message: String?
    var data: [FavouriteModel]?
}

struct LuogoDetailsResponse: Codable{
    var status, message: String?
    var data: LuogoDetails?
}
