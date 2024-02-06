//
//  Configuration.swift
//  myMerenda
//
//  Created by Manuela on 13/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//

import Foundation
import UIKit

struct Instances {

    static var beaconScanner: BeaconScanner!
    
}




//MARK: - Label Style


class Common {
    
    class func printFonts() {
        for family: String in UIFont.familyNames {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}





// MARK: - GRAFICA

extension AppDelegate {
    
    func customAppearance() {
        //Settiamo la UI della navigation bar
        
        // Imposto navbar nera
        UINavigationBar.appearance().tintColor = .label
        
        
        
        let appearance = UITabBarAppearance()
            
        // set padding between tabbar item title and image
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        
        UITabBar.appearance().standardAppearance = appearance
//        self.tabBar.standardAppearance = appearance
    }
    
}

