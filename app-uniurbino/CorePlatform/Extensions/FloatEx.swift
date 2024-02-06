//
//  FloatEx.swift
//  myMerenda
//
//  Created by Be Ready Software on 29/09/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Foundation
extension Float {
    func setFloat(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension Double {
    func string(fractionDigits:Int) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = fractionDigits
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
}
}
