//
//  AlertView.swift
//  ITWA
//
//  Created by Manuela on 24/04/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation
import UIKit


class AlertView {

    class func ok(title:String?, message:String?, completed:(()->Void)?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let destructiveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            completed?()
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(destructiveAction)
        if let topController = ViewControllerUtility.topViewController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }

    
    class func ok(controller: UIViewController,title:String?, message:String?, completed:(()->Void)?){
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let destructiveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            completed?()

            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(destructiveAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func okAlignLeft(title:String?, message:String?, completed:(()->Void)?){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let attributedMessageText = NSMutableAttributedString(
            string: message ?? "",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.setValue(attributedMessageText, forKey: "attributedMessage")
        
        let destructiveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            completed?()
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(destructiveAction)
        if let topController = ViewControllerUtility.topViewController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func openStore(controller: UIViewController,title:String?, message:String?, completed:((_ success:Bool)->Void)?){
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "OK".customLocalized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: Config.appleStoreLink) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                        completed?(true)
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                    completed?(true)
                }
                
            }else {
                completed?(false)
            }

            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(settingsAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func cancel(controller: UIViewController,title:String?, message:String?){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
      
        let settingsAction = UIAlertAction(title: "Conferma".customLocalized, style: .default) { (_) -> Void in
                   alertController.dismiss(animated: true, completion: nil)

               }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Annulla".customLocalized, style: .default) {
            (result : UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        settingsAction.isEnabled = false
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func confirm(controller: UIViewController,title:String?, message:String?, completed:((_ confirmed:Bool)->Void)?){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
      
        let settingsAction = UIAlertAction(title: "Conferma".customLocalized, style: .default) { (_) -> Void in
            completed?(true)
            alertController.dismiss(animated: true, completion: nil)

        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Annulla".customLocalized, style: .default) {
            (result : UIAlertAction) -> Void in
            
            completed?(false)
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func goToSettings(controller: UIViewController,title:String?, message:String?, completed:((_ confirmed:Bool)->Void)?){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
      
        let settingsAction = UIAlertAction(title: "Vai alle impostazioni".customLocalized, style: .default) { (_) -> Void in
            completed?(true)
            alertController.dismiss(animated: true, completion: nil)

        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Annulla".customLocalized, style: .default) {
            (result : UIAlertAction) -> Void in
            
            completed?(false)
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func confirmNotifica(controller: UIViewController,title:String?, message:String?, completed:((_ confirmed:Bool)->Void)?){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
      
        let settingsAction = UIAlertAction(title: "Attiva Notifiche".customLocalized, style: .default) { (_) -> Void in
            completed?(true)
            alertController.dismiss(animated: true, completion: nil)

        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Annulla".customLocalized, style: .default) {
            (result : UIAlertAction) -> Void in
            
            completed?(false)
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
}
