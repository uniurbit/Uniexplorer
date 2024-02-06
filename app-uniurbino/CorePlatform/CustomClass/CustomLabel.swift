//
//  CustomTextFieldEx.swift
//  Vivibanca
//
//  Created by Lorenzo on 08/02/22.
//

import Foundation
import UIKit

class UppercasedLabel: UILabel {
    override var text: String? {
        didSet {
            super.text = text?.uppercased()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        super.text = text?.uppercased()
    }
}
