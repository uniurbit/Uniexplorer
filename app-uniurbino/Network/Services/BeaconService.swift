//
//  BeaconService.swift
//  app-uniurbino
//
//  Created by Lorenzo on 31/01/23.
//

import Foundation
class BeaconService{
    static func getAll(completion: @escaping ([PalazzoModel])->Void, completionError: @escaping (ApiError)->Void) {
        APIClient.performRequest(route: APIRouter.getAll, completion: { (result:PalazzoModelResponse) in
            print(result.toJsonString())
            // Assegno il majorNumber ad ogni palazzo, dato che non lo fanno loro da API ma lo mettono solo nei luoghi

            if var customResult = result.data{
                for (i, palazzo) in customResult.enumerated() {
                    customResult[i].majorNumber = palazzo.luoghi!.first!.majorNumber
                }
                completion(customResult)
            }else{
                completionError(ApiError(.ServerError, errorMessage: result.message))
            }
            
        },completionError: { error in
            completionError(error)
        })
    }

    static func getPreferiti(idUtente: String, completion: @escaping ([FavouriteModel])->Void, completionError: @escaping (ApiError)->Void) {
            APIClient.performRequest(route: APIRouter.getPreferiti(idUtente: idUtente), completion: { (result:FavouriteModelResponse) in
                if let data = result.data{
                    completion(data)
                }else{
                    completionError(ApiError(.ServerError, errorMessage: result.message))
                }
                
            },completionError: { error in
                completionError(error)
            })
        }
    
    static func getLuogo(uuid: String, major: String, minor: String, completion: @escaping (LuogoDetails)->Void, completionError: @escaping (ApiError)->Void) {
              APIClient.performRequest(route: APIRouter.getLuogo(uuid: uuid, major: major, minor: minor), completion: { (result:LuogoDetailsResponse) in
                  if let data = result.data{
                      completion(data)
                  }else{
                      completionError(ApiError(.ServerError, errorMessage: result.message))
                  }
                  
              },completionError: { error in
                  completionError(error)
              })
          }
    
    static func deleteLuogo(idUtente: String, uuid: String, major: Int, minor: Int, completion: @escaping (ApiSucces)->Void, completionError: @escaping (ApiError)->Void) {
        APIClient.performRequest(route: APIRouter.deleteLuogo(idUtente: idUtente, uuid: uuid, major: major, minor: minor), completion: { (result:ApiSucces) in
                  completion(result)
              },completionError: { error in
                  completionError(error)
              })
          }
    
    static func addLuogo(idUtente: String, uuid: String, major: Int, minor: Int, completion: @escaping (ApiSucces)->Void, completionError: @escaping (ApiError)->Void) {
               APIClient.performRequest(route: APIRouter.addLuogo(idUtente: idUtente, uuid: uuid, major: major, minor: minor), completion: { (result:ApiSucces) in
                   completion(result)
               },completionError: { error in
                   completionError(error)
               })
           }
}
