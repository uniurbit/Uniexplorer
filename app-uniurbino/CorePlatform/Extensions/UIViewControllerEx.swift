//
//  UIViewControllerEx.swift
//  ITWA
//
//  Created by Manuela on 24/04/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerUtility {
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        
        return nil
    }

}


extension UIViewController {
    
    // Fonte della gestione della stored property https://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c
    
    struct Holder {
        static var _activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        static var _containerActivityIndicator: UIView = UIView(frame: UIScreen.main.bounds)
    }
    
    var activityIndicator: UIActivityIndicatorView {
        get {
            return Holder._activityIndicator
        }
        set(newValue) {
            Holder._activityIndicator = newValue
        }
    }
    
    var containerActivityIndicator: UIView {
        get {
            return Holder._containerActivityIndicator
        }
        set(newValue) {
            Holder._containerActivityIndicator = newValue
        }
    }
    
    func showActivityIndicator(blockView: Bool = false) {
        containerActivityIndicator = UIView(frame: UIScreen.main.bounds)
        containerActivityIndicator.backgroundColor = UIColor.clear
        containerActivityIndicator.addToWindow()
        if blockView{
            view.isUserInteractionEnabled = false
        }
        view.addSubview(containerActivityIndicator)
        containerActivityIndicator.autoresizingMask = .flexibleHeight

        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        containerActivityIndicator.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator() {
        view.isUserInteractionEnabled = true
        containerActivityIndicator.removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    
    
    func addShadow(view: UIView){
        view.layer.shadowColor = UIColor.SHADOW_COLOR.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 25
        view.layer.shadowOpacity = 1
    }
    
    func removeShadow(view: UIView){
        view.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func showSuccesAlert(title:String?=nil, message:String, ok:(() -> Void)? = nil){
        let titolo = title != nil ? title : ""
        AlertView.ok(title: titolo, message: message, completed: {
            ok?()
        })
    }
    

    
    func showInfoAlert(title:String?=nil, message:String, ok:(() -> Void)? = nil){
        let titolo = title != nil ? title : "Info".customLocalized
        AlertView.ok(title: titolo, message: message, completed: {
            ok?()
        })
    }
    
    func showInfoAlertAlignLeft(title:String?=nil, message:String, ok:(() -> Void)? = nil){
        let titolo = title != nil ? title : "Info".customLocalized
        AlertView.okAlignLeft(title: titolo, message: message, completed: {
            ok?()
        })
    }
    
    func showErrorAlert(title:String?=nil, message:String, ok:(() -> Void)? = nil){
        let titolo = title != nil ? title : "Attenzione".customLocalized
        AlertView.ok(title: titolo, message: message, completed: {
            ok?()
        })
    }
    
    func showErrorAlertAndGoToLogin(message:String){
        let titolo = title != nil ? title : "Attenzione".customLocalized
        AlertView.ok(title: titolo, message: message, completed: {
            UserSettingsManager.sharedInstance.saveUser(user: nil)
        })
    }
    
    func manageErrorConnection(){
        showErrorAlert(message: "Errore di connessione".customLocalized)
    }
    
    func manageSwiftError(){
        showErrorAlert(message: "Errore di caricamento dei dati".customLocalized)
    }
    
    func manageServerError(_ errorMessage: String) {
        showErrorAlert(message: errorMessage)
    }
    
    func manageApiError(error:ApiError)->Void{
        guard let message = error.message else{
            manageServerError("Errore di caricamento dei dati".customLocalized)
            return
        }
        manageServerError(message)
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    /* INIZIO metodi per la gestione dell'apertura della tastiera e view
     Shifta tutta la view in alto quando viene aperta la tastiera */
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func hideKeyboard(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /* FINE gestione apertura tastiera e view */
    
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-200, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.9
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
