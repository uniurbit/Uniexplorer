//
//  DictionaryEx.swift
//  Plin
//
//  Created by Be Ready Software on 27/08/21.
//

import Foundation
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    mutating func conc<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
}
