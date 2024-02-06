//
//  CustomDateTextField.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit


class DateTextField: TextFieldWithPadding{
    public var dateDidEnd: ((String) -> Void)?
    public var dateDidBegin: ((String) -> Void)?

    public lazy var dateTextFieldDelegate = DateTextFieldDelegate(dateTextFieldDelegate: self, only_month_year: false)
    var only_month_year = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initText()
    }
    
    func initText(){
        self.keyboardType = .numberPad
        addTarget(self, action: #selector(textDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textDidBegin), for: .editingDidBegin)

    }
    
    
    public func configure(_ only_month_year: Bool){
        self.only_month_year = only_month_year
        dateTextFieldDelegate = DateTextFieldDelegate(dateTextFieldDelegate: self, only_month_year: only_month_year)
        self.delegate = dateTextFieldDelegate
    }
    
    @objc private func textDidBegin(sender: DateTextField) {
        sender.text = ""
        dateDidBegin?(sender.text ?? "")
//        if only_month_year{
//            if sender.text?.count == 8{
//                sender.text = ""
//            }
//        }else{
//            if sender.text?.count == 10{
//                sender.text = ""
//            }
//        }
    }
    
    @objc private func textDidEnd(sender: DateTextField) {
        dateDidEnd?(sender.text ?? "")
    }
    
    @objc private func textDidChange(sender: DateTextField) {
        if only_month_year{
            if sender.text?.count == 8{
                dateDidEnd?(sender.text ?? "")
                self.resignFirstResponder()
            }
        }else{
            if sender.text?.count == 10{
                dateDidEnd?(sender.text ?? "")
                self.resignFirstResponder()
            }
        }
       
    }
    
}


class DateTextFieldDelegate: NSObject, UITextFieldDelegate {
    let dateTextField: DateTextField
    let only_month_year: Bool!
    init(dateTextFieldDelegate: DateTextField, only_month_year: Bool) {
        self.dateTextField = dateTextFieldDelegate
        self.only_month_year = only_month_year
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !only_month_year{
            if (self.dateTextField.text?.count == 2) || (self.dateTextField.text?.count == 5) {
                if !(string == "") {
                    dateTextField.text = (dateTextField.text)! + "/"
                }
            }
            //&& (range.location == 2 || range.location == 5)
//            if string == "" {
//                return false
//            }
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        }else{
            if (dateTextField.text?.count == 2){
                if !(string == "") {
                    dateTextField.text = (dateTextField.text)! + "/"
                }
            }
            return !(textField.text!.count > 6 && (string.count ) > range.length)
        }
    }
}

