//
//  UIStackViewEx.swift
//  Vivibanca
//
//  Created by Lorenzo on 21/03/22.
//

import Foundation
import UIKit
extension UIStackView{
    func setVerticalStackView(with spacing: CGFloat){
        self.axis = .vertical
        self.spacing = spacing
        self.distribution = .fillProportionally
    }
    
    func setVerticalStackViewWithFill(with spacing: CGFloat){
        self.axis = .vertical
        self.spacing = spacing
        self.distribution = .fill
    }
    
    func setHorizontalStackView(with spacing: CGFloat){
        self.axis = .horizontal
        self.spacing = spacing
        self.distribution = .fill
    }
    
}
