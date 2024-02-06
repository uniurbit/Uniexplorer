//
//  BeaconModel.swift
//  app-uniurbino
//
//  Created by Lorenzo on 31/01/23.
//

import Foundation
struct BeaconModel: Codable, Hashable{
    var id: String?
    var nomeEdificio: String?
    var luoghi: [LuogoModel]?
}

