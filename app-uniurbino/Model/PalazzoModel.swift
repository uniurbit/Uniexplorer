//
//  BeaconModel.swift
//  app-uniurbino
//
//  Created by Lorenzo on 31/01/23.
//

import Foundation
import CoreLocation

struct PalazzoModel: Codable {
    internal init(idPalazzo: String? = nil, nome: String? = nil, majorNumber: Int? = nil, minorNumber: Int? = nil, luoghi: [LuogoModel]? = nil) {
        self.idPalazzo = idPalazzo
        self.nome = nome
        self.majorNumber = majorNumber
        self.minorNumber = minorNumber
        self.luoghi = luoghi
    }
    
    var idPalazzo: String?
    var nome: String?
    var majorNumber: Int? // Changed the type to Int
    var minorNumber: Int? // Changed the type to Int
    
    var luoghi: [LuogoModel]?
    
    enum CodingKeys: String, CodingKey {
        case idPalazzo = "idEdificio"
        case nome = "nomeEdificio"
        case majorNumber
        case minorNumber
        case luoghi
    }
    
    // Decodifico da String ad Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idPalazzo = try container.decodeIfPresent(String.self, forKey: .idPalazzo)
        nome = try container.decodeIfPresent(String.self, forKey: .nome)
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
        luoghi = try container.decodeIfPresent([LuogoModel].self, forKey: .luoghi)
    }
}

struct PalazzoModelResponse: Codable{
    var status, message: String?
    var data: [PalazzoModel]?
}


struct LuogoModel: Codable, Hashable {
    internal init(idLuogo: String? = nil, uuid: String? = nil, nome: String? = nil, testo: String? = nil, accuracy: Double? = nil, CLProximity: Int? = nil, minorNumber: Int? = nil, majorNumber: Int? = nil) {
        self.idLuogo = idLuogo
        self.uuid = uuid
        self.nome = nome
        self.testo = testo
        self.accuracy = accuracy
        self.CLProximity = CLProximity
        self.minorNumber = minorNumber
        self.majorNumber = majorNumber
    }
    
    var idLuogo: String?
    var uuid: String?
    var nome: String?
    var testo: String?
    var accuracy: Double?
    var CLProximity: Int?
    var minorNumber: Int?
    var majorNumber: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case idLuogo = "idStanza"
        case nome = "nomeStanza"
        case uuid
        case testo
        case accuracy
        case CLProximity
        case minorNumber
        case majorNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idLuogo = try container.decodeIfPresent(String.self, forKey: .idLuogo)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        nome = try container.decodeIfPresent(String.self, forKey: .nome)
        testo = try container.decodeIfPresent(String.self, forKey: .testo)
        accuracy = try container.decodeIfPresent(Double.self, forKey: .accuracy)
        CLProximity = try container.decodeIfPresent(Int.self, forKey: .CLProximity)
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

struct FullBeaconScan {
    var lastAccuracy: Double  // Ultima accuracy rilevata
    var averageAccuracy: Double? // Accuracy media
    var rssi: Int
    /// In metri, calcolata da funzione getDistance
    var distance: Double
    var idLuogo: String
    var nomeLuogo: String
    var minor: Int
    var major: Int
    var uuid: String
    
}
