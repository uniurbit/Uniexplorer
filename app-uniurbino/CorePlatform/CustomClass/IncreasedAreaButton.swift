//
//  File.swift
//  MySym
//
//  Created by Be Ready Software on 19/07/22.
//

import UIKit

// Classe che aumenta l'area cliccabile del bottone
class IncreasedAreaButton: GenericButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -30, dy: -30).contains(point)
    }
    
}
