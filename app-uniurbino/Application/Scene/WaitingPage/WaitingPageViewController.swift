//
//  WaitingPageViewController.swift
//  app-uniurbino
//
//  Created by Lorenzo on 23/02/23.
//

import UIKit
import CoreLocation
import CoreBluetooth

class WaitingPageViewController: GenericVC, CLLocationManagerDelegate {
   

    @IBOutlet var bleView: GenericView!
    @IBOutlet var gpsView: GenericView!
    @IBOutlet var gpsImg: UIImageView!
    @IBOutlet var bleImg: UIImageView!
    @IBOutlet weak var permessiStack: UIStackView!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var continuaButton: GenericButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var locationManager: CLLocationManager!
    var centralManager: CBCentralManager!
    var bleIsOn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        permessiStack.isHidden = true
        logoImageView.isHidden = false
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goToSettings))
        permessiStack.addGestureRecognizer(gesture)
        askAllBeacon()
        clearElapsedSnoozedBeacons()
    }

    override func viewWillAppear(_ animated: Bool) {
        askPermissions()
    }
    
    func askAllBeacon(){
        BeaconService.getAll(completion: { res in
            UserSettingsManager.sharedInstance.saveAllPalazzi(palazzi: res)
            self.getCalendar()
        }, completionError: { error in
            if UserSettingsManager.sharedInstance.getAllPalazzi() != nil{
                self.getCalendar()
            }else{
                Logger.log.error("Array dei palazzi vuoto")
                AlertView.ok(title: "Attenzione!", message: "Si è verificato durante il recupero delle aule, se il problema persiste contattare l'assistenza", completed: nil)
            }
        })
    }
    
    func getCalendar(){
        guard let user = UserSettingsManager.sharedInstance.getSavedUser(), user.isUniurbUser == true else {
            UserSettingsManager.sharedInstance.saveCalendar(calendar: nil)
            self.checkAuthorizationAndGoInApp()
            return
        }
        UserService.getCalendar(completion: { result in
            print(result.toJsonString())
            self.checkAuthorizationAndGoInApp()
        }, completionError: { error in
            self.checkAuthorizationAndGoInApp()
        })
    }

    // Cancello tutti i silenziamenti scaduti dei beacon, per evitare che l'array rimanga sporco
    func clearElapsedSnoozedBeacons() {
        var snoozedBeacons = UserSettingsManager.sharedInstance.getNotifications().snoozedBeacons
        snoozedBeacons.removeAll(where: {
            abs($0.snoozedDate.timeIntervalSinceNow) > (Double($0.snoozeDuration.rawValue) * 3600)
        })
    }
    
    func askPermissions() {
        if locationManager.authorizationStatus == .denied {
            permessiStack.isHidden = false
            logoImageView.isHidden = true
        }
        locationManager.requestWhenInUseAuthorization()
    }

    private func setgpsView(isOk: Bool){
        if isOk{
            gpsView.backgroundColor = UIColor.green.withAlphaComponent(0.33)
            gpsImg.image = UIImage(systemName: "checkmark")
            gpsImg.tintColor = UIColor.green
        }else{
            gpsView.backgroundColor = UIColor(hex: "FFBCB2").withAlphaComponent(0.33)
            gpsImg.image = UIImage(systemName: "exclamationmark.circle.fill")
            gpsImg.tintColor = UIColor.red

        }
    }
    
    private func setBleView(isOk: Bool){
        if isOk{
            bleView.backgroundColor = UIColor.green.withAlphaComponent(0.33)
            bleImg.image = UIImage(systemName: "checkmark")
            bleImg.tintColor = UIColor.green
        }else{
            bleView.backgroundColor = UIColor(hex: "FFBCB2").withAlphaComponent(0.33)
            bleImg.image = UIImage(systemName: "exclamationmark.circle.fill")
            bleImg.tintColor = UIColor.red
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationAndGoInApp()
    }
    
    @IBAction func continuaButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @objc func goToSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func checkAuthorizationAndGoInApp() {
        if checkGps() && (bleIsOn ?? false){
            goInApp()
        }else{
            if bleIsOn == nil && checkGps(){
                return
            }
            permessiStack.isHidden = false
            logoImageView.isHidden = true
        }
    }
    
    private func checkGps() -> Bool{
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            setgpsView(isOk: true)
            return true
        } else {
            setgpsView(isOk: false)
            return false
        }
    }
    
    
    
    func goInApp() {
        guard UserSettingsManager.sharedInstance.getSavedUser()?.id != nil else{
            goToLoginPage()
            return
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = mainStoryboard.instantiateViewController(identifier: "tabBarVC") as! MyTabBarController
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.modalTransitionStyle = .crossDissolve
        self.present(tabBarVC, animated: true)
    }

    func goToLoginPage() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "loginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}

extension WaitingPageViewController: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            Logger.log.info("Bluetooth is on")
            bleIsOn = true
            setBleView(isOk: true)

        } else {
            Logger.log.info("Bluetooth is off")
            bleIsOn = false
            setBleView(isOk: false)
        }
        if (bleIsOn ?? false) && checkGps(){
            goInApp()
        }else{
            permessiStack.isHidden = false
            logoImageView.isHidden = true
        }
    }
}
