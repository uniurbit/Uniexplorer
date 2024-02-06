//
//  UIColorEx.swift
//  ITWA
//
//  Created by Manuela on 22/04/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import UIKit

extension UIColor {
    
    
    static let PRIMARY_COLOR = UIColor(hex: "EA4126")
    static let SECONDARY_COLOR = UIColor(hex: "3A86FF")
    static let NAVIGATION = UIColor(hex: "0c78f4")
    
    static let PRIMARYTEXT_COLOR = UIColor(hex: "262626")
    static let SHADOW_COLOR = UIColor(hex: "c1c6c8").withAlphaComponent(0.6)

    
    
    convenience init? (hexx: String) {
         var hexSanitized = hexx.trimmingCharacters(in: .whitespacesAndNewlines)
         hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: Float = 0.0

         var r: CGFloat = 0.0
         var g: CGFloat = 0.0
         var b: CGFloat = 0.0
         var a: CGFloat = 1.0

         let length = hexSanitized.count

         guard Scanner(string: hexSanitized).scanHexFloat(&rgb) else { return nil }

         if length == 6 {
            r = CGFloat((Int(rgb) & 0xFF0000) >> 16) / 255.0
            g = CGFloat((Int(rgb) & 0x00FF00) >> 8) / 255.0
            b = CGFloat(Int(rgb) & 0x0000FF) / 255.0

         } else if length == 8 {
            r = CGFloat((Int(rgb) & 0xFF000000) >> 24) / 255.0
            g = CGFloat((Int(rgb) & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((Int(rgb) & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(Int(rgb) & 0x000000FF) / 255.0

         } else {
             return nil
         }
        self.init(red: r, green: g, blue: b, alpha: a)
     }

     // MARK: - Computed Properties

     var toHex: String? {
         return toHex()
     }

     // MARK: - From UIColor to String

     func toHex(alpha: Bool = false) -> String? {
         guard let components = cgColor.components, components.count >= 3 else {
             return nil
         }

         let r = Float(components[0])
         let g = Float(components[1])
         let b = Float(components[2])
         var a = Float(1.0)

         if components.count >= 4 {
             a = Float(components[3])
         }

         if alpha {
             return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
         } else {
             return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
         }
     }

    
    convenience init(hex: String?) {
        var myHex = hex
        if myHex == nil{
            myHex = ""
        }
        var color = ""
        if myHex?.first == "#"{
            color = String(myHex!.dropFirst())
        }else{
            color = myHex ?? ""
        }
        let scanner = Scanner(string: color)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
