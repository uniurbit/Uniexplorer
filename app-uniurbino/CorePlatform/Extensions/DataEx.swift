//
//  DataEx.swift
//  MySym
//
//  Created by Lorenzo on 12/09/22.
//

import Foundation
extension Data {
    var isPDF: Bool {
        guard self.count >= 1024 else { return false }
        let pdfHeader = Data(bytes: "%PDF", count: 4)
        return self.range(of: pdfHeader, options: [], in: Range(NSRange(location: 0, length: 1024))) != nil
    }
}
