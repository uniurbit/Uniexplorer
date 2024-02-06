//
//  LoginViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 20/01/23.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: GenericVC {


    @IBOutlet weak var accessBtn: UIButton!
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsView.layer.cornerRadius = 10
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
    }

    
    func goToStartScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(identifier: "tabBarVC") as? MyTabBarController
        tabBarVC!.modalPresentationStyle = .fullScreen
        self.present(tabBarVC!, animated: false)
    }
    
    
    @IBAction func sowStartVC(_ sender: UIButton) {
        if sender.tag == 0 {
            googleLogin()
        } else if sender.tag == 1 {
            goToStartScreen()
        }
    }
    
    private func googleLogin(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        self.showActivityIndicator()
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self, completion: { user, error in
            if let error{
                Logger.log.error("Error google login\(error.localizedDescription)")
                self.hideActivityIndicator()
                return
            }
            let userRequest = UserModelRequest(nome: user?.user.profile?.givenName, cognome: user?.user.profile?.familyName ?? "", email: user?.user.profile?.email, pushId: UserSettingsManager.sharedInstance.pushIdentifierString)
                
            guard let accessToken = user?.user.accessToken, let idToken = user?.user.idToken else {
                Logger.log.error("Error getting token")
                self.hideActivityIndicator()
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { authResult, error in
                if let error{
                    Logger.log.error("Error in firebase auth\(error.localizedDescription)")
                    self.hideActivityIndicator()
                    return
                }
                //RICHIAMO LA LOGIN
                self.hideActivityIndicator()
                let userToSave = UserModel()
                userToSave.imgUrl = user?.user.profile?.imageURL(withDimension: 100)?.absoluteString
                UserSettingsManager.sharedInstance.saveUser(user: userToSave)
                self.login(userRequest: userRequest)
            })
            
        })
    }
    
    private func login(userRequest: UserModelRequest){
        self.showActivityIndicator()
        UserService.postLogin(userRequest: userRequest, completion: { [self]_ in
            hideActivityIndicator()
            getCalendar()
        }, completionError: { [self] err in
            hideActivityIndicator()
            manageApiError(error: err)
        })
    }
    
    func getCalendar(){
        guard let user = UserSettingsManager.sharedInstance.getSavedUser(), user.isUniurbUser == true else {
            UserSettingsManager.sharedInstance.saveCalendar(calendar: nil)
            self.goToStartScreen()
            return
        }
        UserService.getCalendar(completion: { result in
            print(result.toJsonString())
            self.goToStartScreen()
        }, completionError: { error in
            self.goToStartScreen()
        })
    }
 

}

