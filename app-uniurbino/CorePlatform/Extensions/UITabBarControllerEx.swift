//
//  UITabBarControllerEx.swift
//  Plin
//
//  Created by Be Ready Software on 09/08/21.
//

import Foundation
import UIKit

extension UITabBarController {
    func setTabBarVisible(visible:Bool, animated:Bool) {
        if visible{
            self.tabBar.isHidden = false
        }else{
            self.tabBar.isHidden = true
        }
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height + 1
        let offsetY = (visible ? -height : height)

        // animation
        self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }

    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
