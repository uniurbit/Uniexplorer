//
//  LocationUtility.swift
//  ITWA
//
//  Created by Daniele Benedetti on 12/05/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtility{
    static func convertLatLongToAddress(latitude:Double,longitude:Double,completion:@escaping (String)->Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            //let locationName = placeMark.location
            guard placeMark != nil else{
                Logger.log.error("error \(error?.localizedDescription ?? "")")
                completion("")
                return
            }
            // Street address
            let street = placeMark.thoroughfare ?? ""
            // number
            let number = placeMark.subThoroughfare ?? ""
            // City
            let city = placeMark.locality ?? ""
            // Provincia
            let prov = placeMark.subAdministrativeArea ?? ""
            //let regione = placeMark.administrativeArea ?? ""
            // Zip code
            let zip = placeMark.postalCode ?? ""
            // Country
            let country = placeMark.country ?? ""
            
            let descr = "\(street) \(number) - \(zip) \(city) (\(prov)) - \(country)"
            
            completion(descr)
        })
    }
    
    static func convertLatLongToCity(latitude:Double,longitude:Double,completion:@escaping (String)->Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            //let locationName = placeMark.location
            guard placeMark != nil else{
                Logger.log.error("error \(error?.localizedDescription ?? "")")
                completion("")
                return
            }
            // City
            let city = placeMark.locality ?? ""
            
            let descr = "\(city)"
            
            completion(descr)
        })
    }
    
    static func convertLatLongToAddress2Linee(latitude:Double,longitude:Double,completion:@escaping (CLPlacemark)->Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            //let locationName = placeMark.location
            // Street address
            guard placeMark != nil else{
                Logger.log.info("error \(error?.localizedDescription ?? "")")
                completion(placeMark)
                return
            }
            
            //completion(["FormattedAddressLines":[descr1,descr2,descr3]])
            completion(placeMark)
        })
    }
    
    static func getAddressFromLocation(location: CLLocation, completed:((_ clPlacemark:CLPlacemark?)->Void)?){
        CLGeocoder().reverseGeocodeLocation(location) { (places, error) in
            guard error == nil else {
                completed?(nil)
                return
            }
            if places?.first != nil{
                completed?(places?.first!)
            }else{
                completed?(nil)
            }
        }
    }
        
//    static func convertLatLongToPoi(latitude:Double,longitude:Double,name:String,completion:@escaping (PoiModel)->Void) {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//            // Location name
//            //let locationName = placeMark.location
//            guard placeMark != nil else{
//                logw(error?.localizedDescription ?? "")
//                completion(PoiModel(lat: latitude, lon: longitude, street: "", number: "", city: "", prov: "", regione: "", cap: "", country: ""))
//                return
//            }
//            // Street address
//            let street = placeMark.thoroughfare ?? ""
//            // number
//            let number = placeMark.subThoroughfare ?? ""
//            // City
//            let city = placeMark.locality ?? ""
//            // Provincia
//            let prov = placeMark.subAdministrativeArea ?? ""
//            let regione = placeMark.administrativeArea ?? ""
//            // Zip code
//            let zip = placeMark.postalCode ?? ""
//            // Country
//            let country = placeMark.country ?? ""
//            
//            let poi = PoiModel(lat: latitude, lon: longitude, street: street, number: number, city: city, prov: prov, regione: regione, cap: zip, country: country)
//            completion(poi)
//        })
//    }
//    
//    static func convertPlacemarkToPoi(placeMark: CLPlacemark,name:String,completion:@escaping (PoiModel)->Void) {
//        // Street address
//        let street = placeMark.thoroughfare ?? ""
//        // number
//        let number = placeMark.subThoroughfare ?? ""
//        // City
//        let city = placeMark.locality ?? ""
//        // Provincia
//        let prov = placeMark.subAdministrativeArea ?? ""
//        let regione = placeMark.administrativeArea ?? ""
//        // Zip code
//        let zip = placeMark.postalCode ?? ""
//        // Country
//        let country = placeMark.country ?? ""
//        
//        let poi = PoiModel(lat: 0, lon: 0, street: street, number: number, city: city, prov: prov, regione: regione, cap: zip, country: country)
//        completion(poi)
//    }
}
