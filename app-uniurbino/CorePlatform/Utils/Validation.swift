//
//  Validation.swift
//  JON-Salon
//
//  Created by Lorenzo on 06/06/22.
//  Copyright © 2022 Balzo. All rights reserved.
//

import Foundation
class Validation {
    class func validateCode(code: String?) ->Bool {
        guard let code = code else {return false}
        // Length be 5 characters 
        let nameRegex = "^\\w{5}$"
        let trimmedString = code.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    class func validaPhoneNumber(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else {return false}
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    class func validateEmailId(emailID: String?) -> Bool {
        guard let emailID = emailID else {return false}
        return emailID.isValidEmail()
    }
    
    class func validatePassword(password: String?) -> Bool {
        guard let password = password else {return false}
        //Minimum 10 characters && special char:
//        ^                         Start anchor
//        (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
//        (?=.*[!@#$&*])            Ensure string has one special case letter.
//        (?=.*[0-9].*[0-9])        Ensure string has two digits.
//        (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
//        .{8}                      Ensure string is of length 8.
//        $
        let passRegEx = "^.*(?=.{10,})(?=.*[!#$%&? ]).*$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    class func validateTextField(fieldString: String?) -> Bool {
        guard let fieldString = fieldString else {return false}
        let trimmedString = fieldString.trimmingCharacters(in: .whitespaces)
        if trimmedString.isEmpty{
            return false
        }
        return true
    }
}


extension String {
    func isValidEmail() -> Bool {
        guard !self.lowercased().hasPrefix("mailto:") else {
            return false
        }
        guard let emailDetector
            = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let matches
            = emailDetector.matches(in: self,
                                    options: NSRegularExpression.MatchingOptions.anchored,
                                    range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else {
            return false
        }
        return matches[0].url?.scheme == "mailto"
    }
}
