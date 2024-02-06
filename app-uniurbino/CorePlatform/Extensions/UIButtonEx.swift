//
//  UIButtonEx.swift
//  myMerenda
//
//  Created by Manuela on 19/09/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import UIKit

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
    
    func enableBtn(){
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    func disableBtn(){
        self.alpha = 0.4
        self.isUserInteractionEnabled = false
    }
    
    func enableFilterBtn(){
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    func disableFilterBtn(){
        self.alpha = 0.5
        self.isUserInteractionEnabled = false
    }
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
         let border = CALayer()
         border.backgroundColor = color.cgColor
         
         switch side {
         case .Top:
             border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
         case .Bottom:
             border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
         case .Left:
             border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
         case .Right:
             border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
         }
         
         self.layer.addSublayer(border)
     }
}



public extension UIButton {

    @IBInspectable var localizedText: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(newValue?.customLocalized, for: .normal)
        }
    }

}
