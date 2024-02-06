//
//  CustomNavBar.swift
//  Vivibanca
//
//  Created by Lorenzo on 14/02/22.
//

import Foundation
import UIKit

protocol RoundedCornerNavigationBar {
    func addRoundedCorner(OnNavigationBar navigationBar: UINavigationBar, cornerRadius: CGFloat)
}

extension RoundedCornerNavigationBar where Self: UIViewController{
    
    func addRoundedCorner(OnNavigationBar navigationBar: UINavigationBar, cornerRadius: CGFloat){
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .white
        
        let customView = UIView(frame: CGRect(x: 0, y: navigationBar.bounds.maxY, width: navigationBar.bounds.width, height: cornerRadius))
        customView.backgroundColor = .clear
        navigationBar.insertSubview(customView, at: 1)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: customView.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        customView.layer.insertSublayer(shapeLayer, at: 0)
    }
}
