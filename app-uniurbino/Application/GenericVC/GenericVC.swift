//
//  GenericVC.swift
//  myMerenda
//
//  Created by Manuela on 13/08/2020.
//  Copyright © 2020 Be Ready Software. All rights reserved.
//
import UIKit
import Reachability


class GenericVC: UIViewController {

    private var loading:Bool = false {
        didSet{
            backEndTaskLoading(done: loading)
        }
    }
    func backEndTaskLoading(done:Bool)->Void{}
    func setNavigationTitle()->Void{}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        if touch?.view != self.view{
            view.endEditing(true)
        }
    }
    
    func configureBackButton(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.accessibilityLabel = "Bottone indietro"
    }

    
    //  MARK: - custom method

   
    
//  MARK: - connection
    
    func isConnectionAvailable() -> Bool {
        do {
            let reachability = try Reachability(hostname: APIUtils.Server.baseURL)
            if reachability.connection == .unavailable {
                AlertView.ok(controller: self,
                             title: "Attenzione".customLocalized,
                             message: "Questa funzione al momento non è disponibile per assenza di segnale, riprova più tardi!".customLocalized,
                             completed: nil)

                return false
            }
        } catch {
            Logger.log.error("error:  \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func isConnectionAvailableWithoutShowAlert() -> Bool {
        do {
            let reachability = try Reachability(hostname: APIUtils.Server.baseURL)
            if reachability.connection == .unavailable {
                return false
            }
        } catch {
            Logger.log.error("error:  \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    

    
    var scroll: UIScrollView!
    func registerKeyboardNotifications(scrollView: UIScrollView) {
        self.scroll = scrollView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scroll.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scroll.contentInset.bottom = 0
    }

}


extension GenericVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


extension UIView {

    func addToWindow()  {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        self.frame = keyWindow?.window?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        keyWindow?.window?.addSubview(self)
    }
}
