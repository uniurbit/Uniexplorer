//
//  ApiError.swift
//  ITWA
//
//  Created by Daniele Benedetti on 06/05/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation

class ApiError: Decodable{
    var statusCode: Int?
    var errorType: ErrorType?
    var message: String?

    init(_ errorType: ErrorType, statusCode: Int? = nil, errorMessage: String? = nil) {
        self.statusCode = statusCode
        self.message = errorMessage
        self.errorType = errorType
    }
}

class ApiSucces: Decodable{
    var status: String?
    var message: String?

}

enum ErrorType: Decodable {
    case ConnectionError
    case ServerError    // errore 503
    case DecodingError
}
