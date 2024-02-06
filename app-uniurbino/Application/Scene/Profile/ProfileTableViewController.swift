//
//  ProfileTableViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 20/01/23.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var nameCell: UITableViewCell!
    @IBOutlet var surnameCell: UITableViewCell!
    @IBOutlet var emailCell: UITableViewCell!
    @IBOutlet var corsiCell: UITableViewCell!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var blueBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    
    
    let exitImg = UIImage(systemName: "rectangle.portrait.and.arrow.right")
    let accessImg = UIImage(systemName: "iphone.and.arrow.forward")
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.accessibilityLabel = "Bottone indietro"
        
        if user != nil {
            setupForUser()
        } else {
            setupForGuest()
        }
        
        
        
    }
    
    //setting up for logged in user
    func setupForUser() {
        userPhoto.image = UIImage(named: "Vector3")
        nameCell.isHidden = false
        surnameCell.isHidden = false
        emailCell.isHidden = false
        corsiCell.isHidden = false
        blueBtn.setTitle("Esci", for: .normal)
        blueBtn.setImage(exitImg, for: .normal)
        settingsBtn.tag = 0
        if let user = UserSettingsManager.sharedInstance.getSavedUser() {
            nameLabel.text = user.nome
            surnameLabel.text = user.cognome
            mailLabel.text = user.email
            courseLabel.text = user.corsoStudi
            FileUtility.downloadImageFromUrl(imgUrl: user.imgUrl, imgView: userPhoto, placeholderImg: UIImage(named: "Vector3")!)
            userPhoto.layer.cornerRadius = 40
        }
    }
    
    //setting up for guest
    func setupForGuest() {
        userPhoto.image = UIImage(named: "Vector6")
        nameCell.isHidden = true
        surnameCell.isHidden = true
        emailCell.isHidden = true
        corsiCell.isHidden = true
        
        blueBtn.setTitle("Accedi", for: .normal)
        blueBtn.setImage(accessImg, for: .normal)
        settingsBtn.tag = 1
    }
    
    func goToSettingsScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(identifier: "settingsVC") as! SettingsTableViewController
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func goToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true)
    }
    
    
    @IBAction func showSettingsVC(_ sender: UIButton) {
        goToSettingsScreen()
    }
    
    @IBAction func exitOrAccess(_ sender: UIButton) {
        if user != nil { // Se loggato
            logout()
        } else { // Se non loggato
            goToLoginScreen()
        }
    }
    
    // MARK: - Table view data source
    
    // To hide cells with personal info for guest access
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if user == nil,
           indexPath == IndexPath(row: 0, section: 1) ||
           indexPath == IndexPath(row: 1, section: 1) ||
           indexPath == IndexPath(row: 0, section: 2) ||
           indexPath == IndexPath(row: 1, section: 2)
        {
            return 0
        } else {
            return tableView.rowHeight
        }
    }
    
    private func logout(){
        self.showActivityIndicator()
        UserService.logout(completion: { [self]_ in
            hideActivityIndicator()
            UserSettingsManager.sharedInstance.saveUser(user: nil)
            UserSettingsManager.sharedInstance.saveCalendar(calendar: nil)
            goToLoginScreen()
        }, completionError: { [self] err in
            hideActivityIndicator()
            manageApiError(error: err)
        })
    }
}
