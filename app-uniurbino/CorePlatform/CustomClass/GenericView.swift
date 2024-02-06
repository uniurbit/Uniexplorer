//
//  GenericView.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit
class GenericView: UIView {
    
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


class SplitColorView: GenericView {
    
    
    public var firstColor: UIColor = UIColor.clear
    public var secondColor: UIColor = UIColor.clear
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let topRect = CGRect(x: 0, y: 0, width: rect.size.width/2, height: rect.size.height)
        firstColor.set()
        guard let topContext = UIGraphicsGetCurrentContext() else { return }
        topContext.fill(topRect)

        let bottomRect = CGRect(x: rect.size.width/2, y: 0, width: rect.size.width/2, height: rect.size.height)
        secondColor.set()
        guard let bottomContext = UIGraphicsGetCurrentContext() else { return }
        bottomContext.fill(bottomRect)
        self.cornerRadius = 2
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
