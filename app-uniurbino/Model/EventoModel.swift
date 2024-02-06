//
//  EventoModel.swift
//  app-uniurbino
//
//  Created by Lorenzo on 22/02/23.
//

import Foundation
struct EventoModel: Codable {
    var idStanza, uuid: String?
    var majorNumber, minorNumber: Int?
    var nomeStanza, nomeEdificio, inizio, fine: String?
    var dettagli: String?
    
    enum CodingKeys: CodingKey {
        case idStanza
        case uuid
        case majorNumber
        case minorNumber
        case nomeStanza
        case nomeEdificio
        case inizio
        case fine
        case dettagli
    }
    
    // Decodifico da String ad Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idStanza = try container.decodeIfPresent(String.self, forKey: .idStanza)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        nomeStanza = try container.decodeIfPresent(String.self, forKey: .nomeStanza)
        nomeEdificio = try container.decodeIfPresent(String.self, forKey: .nomeEdificio)
        inizio = try container.decodeIfPresent(String.self, forKey: .inizio)
        fine = try container.decodeIfPresent(String.self, forKey: .fine)
        dettagli = try container.decodeIfPresent(String.self, forKey: .dettagli)
        
        do {
            if let majorNumberString = try container.decodeIfPresent(String.self, forKey: .majorNumber){
                majorNumber = Int(majorNumberString)
            }
        }catch{
            majorNumber = try container.decodeIfPresent(Int.self, forKey: .majorNumber)
        }
        do{
            if let minorNumberString = try container.decodeIfPresent(String.self, forKey: .minorNumber) {
                minorNumber = Int(minorNumberString)
            }
        }catch{
            minorNumber = try container.decodeIfPresent(Int.self, forKey: .minorNumber)
        }
    }

}

struct EventoModelResponse: Codable{
    var status, message: String?
    var data: [EventoModel]?
}
