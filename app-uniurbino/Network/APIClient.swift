//
//  APIClient.swift
//  myMerenda
//
//  Created by Manuela on 13/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Alamofire
import Reachability
import Foundation

class APIClient {
    
    static func isConnectionAvailable() -> Bool {
        do {
            let reachability = try Reachability(hostname: APIUtils.Server.baseURL)
            if reachability.connection == .unavailable {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    /**
     performRequest: quando è necessario gestire l'errore a grafica
     */
    static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(),
                                            completion:@escaping (T)->Void,
                                            completionError:@escaping (ApiError)->Void) {
        AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                if let data = response.data {
                    Logger.log.verbose("""
                                       API richiamo la \(route)
                                       Response status code: \(response.response?.statusCode ?? -1)
                                       API body response:
                                       \(String(data: data, encoding: .utf8) ?? "")
                                       """)
                }
                switch response.result {
                case .success(_):
                    let statusCode = response.response!.statusCode
                    switch statusCode {
                    case 200:
                        completion(try! response.result.get())
                    case 400:
                        Logger.log.warning("errore 400")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 400))
                        }
                    case 401:
                        Logger.log.warning("errore 401")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 401))
                        }
                    case 403:
                        Logger.log.warning("errore 403")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 403))
                        }
                    case 404:
                        Logger.log.warning("errore 404")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 404))
                        }
                        
                    default:
                        completionError(ApiError(.ServerError))
                    }
                    
                case .failure(let error):
                    dump(response.result)
                    Logger.log.error("error \(error.errorDescription ?? "")")
                    
                    guard response.response != nil && response.data != nil else {
                        print(error.localizedDescription)
                        completionError(ApiError(.ConnectionError))
                        return
                    }
                    let statusCode = response.response!.statusCode
                    do {
                        let bodyError = try JSONDecoder().decode([String].self, from: response.data!)
                        completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                    }
                    catch {
                        Logger.log.error("error: \(error.localizedDescription)")
                        completionError(ApiError(.DecodingError))
                    }
                    switch statusCode {
                    case 200:
                        Logger.log.warning("errore 200")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data!)
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 200))
                        }
                    case 400:
                        Logger.log.warning("errore 400")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data!)
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 400))
                        }
                    case 401:
                        Logger.log.warning("errore 401")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 401))
                        }
                    case 403:
                        Logger.log.warning("errore 403")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data ?? Data())
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 403))
                        }
                    case 404:
                        Logger.log.warning("errore 404")
                        do {
                            let bodyError = try JSONDecoder().decode([String].self, from: response.data!)
                            completionError(ApiError(.ServerError, statusCode: statusCode, errorMessage: bodyError.first ?? "Errore generico"))
                        }
                        catch {
                            Logger.log.warning("error: \(error.localizedDescription)")
                            completionError(ApiError(.DecodingError, statusCode: 404))
                        }
                    default:
                        completionError(ApiError(.ServerError))
                    }
                }
            }
    }
    
    
    
    //    MARK: - chiamate API
    
    static func downloadFile(url: String, completion:@escaping (AFDataResponse<Data>)->Void) {
        AF.request(url).responseData(completionHandler: { (response) in
            completion(response)
        })
    }
    
}
