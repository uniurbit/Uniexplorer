//
//  StringEx.swift
//  ITWA
//
//  Created by Manuela on 24/04/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto


extension String {
    
    var customLocalized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var sha256: String {
        if let strData = self.data(using: String.Encoding.utf8) {
           /// #define CC_SHA256_DIGEST_LENGTH     32
           /// Creates an array of unsigned 8 bit integers that contains 32 zeros
           var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
    
           /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
           /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            let _ = strData.withUnsafeBytes {
               // CommonCrypto
               // extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)  -|
               // OpenSSL                                                                             |
               // unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md)        <-|
               CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
           }
    
           var sha256String = ""
           /// Unpack each byte in the digest array and add them to the sha256String
           for byte in digest {
               sha256String += String(format:"%02x", UInt8(byte))
           }
           return sha256String
       }
       return ""
    }
    
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func convertToAttributedString() -> NSAttributedString? {
        let modifiedFontString = "<span style=\"font-family: Avenir-Book; font-size: 14; color: rgb(29, 37, 45)\">" + self + "</span>"
        return modifiedFontString.htmlToAttributedString
    }
    
    func getRangeAfter(rangeToSearch: String) -> String{
        let myString = self.components(separatedBy: rangeToSearch)[1]
        return myString
    }
    func getRangeBefore(rangeToSearch: String) -> String{
        let myString = self.components(separatedBy: rangeToSearch)[0]
        return myString
    }
    
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
