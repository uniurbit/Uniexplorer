//
//  IntEx.swift
//  ITWA
//
//  Created by Daniele on 03/09/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    func toCurrency() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        return numberFormatter.string(from: self)
    }
}
