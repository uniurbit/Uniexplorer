//
//  Utility.swift
//  myMerenda
//
//  Created by Manuela on 05/09/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import UIKit
import DeviceCheck
import Contacts
class Utility {
    
    internal static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    class func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    class func getContacts() -> [CNContact] { //  ContactsFilter is Enum find it below

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
    
}

extension GenericVC {
    
    
    
    func openTelephone(telephone: String) {
        let phone = telephone.replacingOccurrences(of: "+", with: "")
        let tel = phone.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(tel)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            UIPasteboard.general.string = telephone
            self.showToast(message: "Numero di telefono copiato".customLocalized)
        }
    }
    
    func openMap(address: String) {
        let addressForUrl = address.replacingOccurrences(of: " ", with: "%20")
        var url: URL? = nil
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
            if let urlT = URL(string: "comgooglemaps://?q=\(addressForUrl)&directionsmode=driving") {
                url = urlT
            }
        }
        else if let urlT = URL(string: "http://maps.apple.com/?address=\(addressForUrl)") {
            url = urlT
        }
        else {
            showErrorAlert(message: "Mi dispiace, non riesco ad aprire la mappa a questo indirizzo.")
        }
        
        // se non posso aprire nè con google maps nè con apple maps
        if !UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) && !UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com")!) {
            showErrorAlert(message: "Mi dispiace, non riesco a trovare una app per aprire questo indirizzo.")
        }
        guard let indirizzo = url else{
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(indirizzo)
        } else {
            UIApplication.shared.openURL(indirizzo)
        }
    }
    
    func openMap(latitude: Double, longitude: Double) {
        var url: URL? = nil
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
            if let urlT = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
            url = urlT
            }
        }
        else if let urlT = URL(string: "http://maps.apple.com/?q=\(latitude),\(longitude)") {
            url = urlT
        }
        else {
            showErrorAlert(message: "Mi dispiace, non riesco ad aprire la mappa a questo indirizzo.")
        }
        
        // se non posso aprire nè con google maps nè con apple maps
        if !UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) && !UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com")!) {
            showErrorAlert(message: "Mi dispiace, non riesco a trovare una app per aprire questo indirizzo.")
        }
        
        guard let indirizzo = url else{
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(indirizzo)
        } else {
            UIApplication.shared.openURL(indirizzo)
        }
    }
    
    func openBrowser(url: String?) {
        guard let urlToOpen = url else {
            return
        }
        if let urlToOpenURL = URL(string: urlToOpen) {
            UIApplication.shared.open(urlToOpenURL)
        }
    }
}
