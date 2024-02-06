//
//  GenericButton.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit


class GenericButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}


class ButtonWithMultipleTag : UIButton {

    var row : Int?
    var section : Int?

}

