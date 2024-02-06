//
//  MyTabBarController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 22/01/23.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet var startTabBar: UITabBar!
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if
            user == nil,
            let navigationController = viewController as? UINavigationController,
            navigationController.viewControllers.first is PuntiViewController
        {
            let ac = UIAlertController(title: "Per poter utilizzare questa funzione devi effettuare il login", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            tabBarController.present(ac, animated: true)
            return false
        } else {
            return true
        }
    }
    
    
}

