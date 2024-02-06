//
//  BottomLineTextField.swift
//  MedyCare
//
//  Created by Lorenzo on 20/06/22.
//
import UIKit
import Foundation
class BottomLineTextField: TextFieldWithPadding {
    

    override func awakeFromNib() {
        super.awakeFromNib()

        let bottomLine = UIView()
        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .black

        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    

    
}
