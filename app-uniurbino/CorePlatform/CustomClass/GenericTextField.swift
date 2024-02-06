//
//  GenericTextField.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit

class CustomTextfield: UITextField {
    
    var validate: Bool = true {
        didSet {
            layer.borderColor = validate ? UIColor.clear.cgColor : UIColor.red.cgColor
            layer.borderWidth = validate ? 0.0 : 1.0
        }
    }
    
    var isChanged: Bool = true {
        didSet {
            layer.borderColor = isChanged ? UIColor.lightGray.cgColor : UIColor.NAVIGATION.cgColor
            layer.borderWidth = isChanged ? 0.0 : 1.0
        }
    }
}


class GenericTextfield: CustomTextfield {
    
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
    
    @IBInspectable var border: Bool = false {
        didSet {
            if border{
                self.borderStyle = .line
            }else{
                self.borderStyle = .none
            }
        }
    }
    
    @IBInspectable var doneAccessory: Bool = true{
        didSet {
            if doneAccessory{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.textColor = UIColor.black
    }
    
    
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = true
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done".customLocalized, style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .white
        doneToolbar.barTintColor = .black
        doneToolbar.alpha = 0.7

        let items = [flexSpace, done, flexSpace]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
