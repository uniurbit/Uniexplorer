//
//  SettingsTableViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 20/01/23.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var lblPreferiti: UILabel!
    
    
    @IBOutlet weak var tutteSwitch: UISwitch!
    @IBOutlet weak var impegniSwitch: UISwitch!
    @IBOutlet weak var preferitiSwitch: UISwitch!
    @IBOutlet weak var backgroundSwitch: UISwitch!
    
    
    @IBOutlet weak var tutteCell: UITableViewCell!
    @IBOutlet weak var impegniCell: UITableViewCell!
    @IBOutlet weak var preferitiCell: UITableViewCell!
    
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var authorizationStatus: UNAuthorizationStatus!
    
    var isGuest = false
    var isUniUrbUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            isGuest = true
            profilePhoto.image = UIImage(named: "Vector6")
        } else if user?.isUniurbUser == true {
            isUniUrbUser = true
            
        }
        
        if let user{
            FileUtility.downloadImageFromUrl(imgUrl: user.imgUrl, imgView: profilePhoto, placeholderImg: UIImage(named: "Vector3")!)
            profilePhoto.layer.cornerRadius = 40
        }
        
        // Per nascondere le celle dalla tableview statica
        tableView.beginUpdates()
        tableView.endUpdates()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.accessibilityLabel = "Bottone indietro"
        
        let notificationSettings = UserSettingsManager.sharedInstance.getNotificationSettings()
        self.updateSwitchs(with: notificationSettings)
        
        let backgroundScanSetting = UserSettingsManager.sharedInstance.backgroundScanSetting
        DispatchQueue.main.async {
            self.backgroundSwitch.setOn(backgroundScanSetting, animated: false)
        }
        
        Instances.beaconScanner.settingsDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfAreNotificationsAllowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(refreshAccess), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
      }
    
      override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
      }
    
    @objc func refreshAccess() {
        // Controllo se l'utente ha attivato le notifiche
        checkIfAreNotificationsAllowed()
    }
    
    @IBAction func notificationSwitchs(_ sender: UISwitch) {
        saveNotificationSettings()
    }
    
    @IBAction func backgroundSwitch(_ sender: UISwitch) {
        DispatchQueue.main.async {
            UserSettingsManager.sharedInstance.backgroundScanSetting = self.backgroundSwitch.isOn
            if self.backgroundSwitch.isOn {
                if Instances.beaconScanner.locationManager.authorizationStatus != .authorizedAlways {
                    AlertView.goToSettings(controller: self, title: "Posizione \"sempre\" non attiva", message: "Apri le impostazioni per attivarla", completed: { completed in
                        if completed {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        UserSettingsManager.sharedInstance.backgroundScanSetting = false
                        self.backgroundSwitch.setOn(UserSettingsManager.sharedInstance.backgroundScanSetting, animated: true)
                    })
                }
            }
        }
    }
    
    func setAllFalse() {
        updateSwitchs(with:
                        NotificationSettingsModel(
                            tutteLeAule: false,
                            auleConImpegni: false,
                            aulePreferite: false)
        )
    }
    
    func updateSwitchs(with notificationSettings: NotificationSettingsModel) {
        DispatchQueue.main.async { [self] in
            tutteSwitch.setOn(notificationSettings.tutteLeAule, animated: true)
            impegniSwitch.setOn(notificationSettings.auleConImpegni, animated: true)
            preferitiSwitch.setOn(notificationSettings.aulePreferite, animated: true)
            if notificationSettings.tutteLeAule {
                impegniCell.alpha = 0.5
                impegniCell.isUserInteractionEnabled = false
                preferitiCell.alpha = 0.5
                preferitiCell.isUserInteractionEnabled = false
            } else {
                impegniCell.alpha = 1
                impegniCell.isUserInteractionEnabled = true
                preferitiCell.alpha = 1
                preferitiCell.isUserInteractionEnabled = true
            }
        }
    }
    
    func checkIfAreNotificationsAllowed() {
        userNotificationCenter.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .denied {
                self.setAllFalse()
                DispatchQueue.main.async {
                    AlertView.goToSettings(controller: self, title: "Notifiche non attive", message: "Apri le impostazioni per attivarle", completed: { completed in
                        if completed {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        })
    }
    
    func saveNotificationSettings() {
        DispatchQueue.main.async { [self] in
            let tutteLeAule = tutteSwitch.isOn
            var auleConImpegni = impegniSwitch.isOn
            var aulePreferite = preferitiSwitch.isOn
            if tutteLeAule { // Se seleziono tutte le aule, imposto tutto a true
                auleConImpegni = true
                aulePreferite = true
            }
            let notificationSettings = NotificationSettingsModel(
                tutteLeAule: tutteLeAule,
                auleConImpegni: auleConImpegni,
                aulePreferite: aulePreferite
            )
            UserSettingsManager.sharedInstance.saveNotificationSettings(notificationSettings)
            updateSwitchs(with: notificationSettings)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = super.tableView(tableView, numberOfRowsInSection: section)
        // Gestisco quali righe faccio vedere in base alla tipologia di utente
        if isGuest, numberOfRows > 2 {
            return 2
        } else if !isUniUrbUser, numberOfRows > 3 {
            return 3
        } else {
            return numberOfRows
        }
    }
}

extension SettingsTableViewController: SettingsDelegate {
    func authorizedAlways(_ isAuthorizedAlways: Bool) {
        // Se c'è stato un cambio di autorizzazione, cambio l'impostazione del background di conseguenza
        DispatchQueue.main.async {
            if isAuthorizedAlways {
                self.backgroundSwitch.setOn(UserSettingsManager.sharedInstance.backgroundScanSetting, animated: true)
            } else {
                UserSettingsManager.sharedInstance.backgroundScanSetting = false
                self.backgroundSwitch.setOn(UserSettingsManager.sharedInstance.backgroundScanSetting, animated: true)
            }
        }
    }
    
}
