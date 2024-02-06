//
//  EncodableEx.swift
//  myMerenda
//
//  Created by Manuela on 29/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Foundation


extension Encodable {

    
    func toStringAny() -> [String:Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let dictionary = try! JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
            return dictionary
        } catch {
            print(error)
            return nil
        }
    }
    
    func objtoJsonString() -> String {
        var dict = Dictionary<String, Any>()
        
        for property in Mirror(reflecting: self).children{
            let val = property.value
            let prop = property.label!
            if val is String {
                dict[prop] = val as! String
            }
            else if val is Int{
                dict[prop] = val as! Int
            }
            else if val is Array<String> {
                dict[prop] = val as! Array<String>
            }
            else if val is Array<Int> {
                dict[prop] = val as! Array<Int>
            }
            else if (val is Array<Encodable>) {
                var arr = Array<NSDictionary>()
                
                for item in (val as! Array<Encodable>) {
                    arr.append(item.toDictionary())
                    print(item.toDictionary())
                }
                
                dict[prop] = arr
            }
            else{
                dict[prop] = val
            }
        }
        
        print(dict)
        
        if let theJSONData = try?  JSONSerialization.data(
             withJSONObject: dict
//             options: .prettyPrinted
             ),
             let theJSONText = String(data: theJSONData,
                                      encoding: String.Encoding.utf8){
            return theJSONText
        }
        
        return ""
    }
    
    func arrtoJsonString() -> String {
        var arr = [Dictionary<String, Any>]()
        var dict = Dictionary<String, Any>()

        for elem in Mirror(reflecting: self).children {
            
            for property in Mirror(reflecting: elem.value).children {
                let val = property.value
                let prop = property.label!
                if val is String {
                    dict[prop] = val as! String
                }
                else if val is Int{
                    dict[prop] = val as! Int
                }
                else if val is Array<String> {
                    dict[prop] = val as! Array<String>
                }
                else if val is Array<Int> {
                    dict[prop] = val as! Array<Int>
                }
                else if (val is Array<Encodable>) {
                    var arr = Array<NSDictionary>()
                    
                    for item in (val as! Array<Encodable>) {
                        arr.append(item.toDictionary())
                    }
                    
                    dict[prop] = arr
                }
                else{
                    dict[prop] = val
                }
            }
            //print(dict.description)
            arr.append(dict)
        }
        
        //print(arr.description)
        
        
        if let theJSONData = try?  JSONSerialization.data(
             withJSONObject: arr
//             options: .prettyPrinted
             ),
             let theJSONText = String(data: theJSONData,
                                      encoding: String.Encoding.utf8){
            return theJSONText
        }
        
        return ""

    }
    
    func toDictionary() -> NSDictionary {
        // make dictionary
        var dict = Dictionary<String, Any>()
        
        for property in Mirror(reflecting: self).children{
            let val = property.value
            let prop = property.label!
            if val is String {
                dict[prop] = val as! String
            }
            else if val is Int{
                dict[prop] = val as! Int
            }
            /*else if val is Encodable
            {
                dict[prop] = (val as! Encodable).toDictionary()
            }*/
            else if (val is Array<Encodable>)
            {
                var arr = Array<NSDictionary>()
                
                for item in (val as! Array<Encodable>) {
                    arr.append(item.toDictionary())
                }
                
                dict[prop] = arr
            }
            else{
                dict[prop] = val
            }
        }
        
//        if let theJSONData = try?  JSONSerialization.data(
//             withJSONObject: dict,
//             options: .prettyPrinted
//             ),
//             let theJSONText = String(data: theJSONData,
//                                      encoding: String.Encoding.ascii){
//            print(theJSONText)
//        }
        
        
        // return dict
        return dict as NSDictionary
    }
    
    
    func toJsonString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(self)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
}
