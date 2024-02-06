//
//  UITextfield.swift
//  myMerenda
//
//  Created by Manuela on 29/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import UIKit
import Foundation

extension UITextField{
    func setColorString(color: UIColor, text: String, fontSize: Int) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        let rangeOfColoredString = (self.text! as NSString).range(of: text)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color],range: rangeOfColoredString)
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))],range: rangeOfColoredString)
        self.attributedText = attributedString
    }
}



