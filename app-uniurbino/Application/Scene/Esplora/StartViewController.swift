//
//  StartViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 20/01/23.
//

import UIKit
import CoreLocation

class StartViewController: GenericVC {
    
    @IBOutlet var userPic: UIButton!
    @IBOutlet var greetingTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    
    let loginVC = LoginViewController()
    var beaconScanner: BeaconScanner!
    
    let userImage = UIImage(named: "Vector3")
    let guestImage = UIImage(named: "Vector7")
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Instances.beaconScanner == nil {
            Instances.beaconScanner = BeaconScanner()
        }
        Instances.beaconScanner.initializeScanner()
        
        Instances.beaconScanner.startDelegate = self
        Instances.beaconScanner.askPreferiti()
        
        
        userPic.isAccessibilityElement = true
        userPic.accessibilityLabel = "Profilo"
        NSLayoutConstraint.activate([
            userPic.widthAnchor.constraint(equalToConstant: 44),
            userPic.heightAnchor.constraint(equalToConstant: 44)
        ])
        userPic.imageView?.contentMode = .scaleAspectFit
        
        navigationItem.largeTitleDisplayMode = .always
        
        
        if user != nil {
            setupForUser()
        } else {
            setupForGuest()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BeaconCell.nibName, forCellReuseIdentifier: BeaconCell.identifier)
        
    }
    
    @IBAction func showProfileVC(_ sender: UIButton) {
        goToProfileScreen()
    }
    
    
    @IBAction func showAddVC(_ sender: UIButton) {
        goToAddScreen()
    }

    //setting up for logged in user
    func setupForUser() {
        userPic.tag = 0
        if let nome = UserSettingsManager.sharedInstance.getSavedUser()?.nome {
            self.navigationItem.title = "Ciao, " + nome + "!"
        } else {
            self.navigationItem.title = "Ciao!"
        }
        
        FileUtility.downloadImageBtnFromUrl(imgUrl: user!.imgUrl, btn: userPic, placeholderImg: UIImage(named: "Vector3")!)
    }
    
    //setting up for guest
    func setupForGuest() {
        userPic.setImage(guestImage, for: .normal)
        userPic.tag = 1
        self.navigationItem.title = "Ciao, " + "Guest" + "!"
        addBtn.isHidden = true
    }
    
    func goToProfileScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(identifier: "profileVC") as! ProfileTableViewController
        navigationItem.backButtonTitle = "Indietro"
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func goToAddScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) 
        let addVC = storyboard.instantiateViewController(identifier: "addPuntoVC") as! AddPuntoViewController
        navigationItem.backButtonTitle = "Indietro"
        navigationController?.pushViewController(addVC, animated: true)
    }
    
}

extension StartViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfBeaconsToShow = Instances.beaconScanner.lastFullScan.count
        if numberOfBeaconsToShow == 0 {
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = nil
        }
        return numberOfBeaconsToShow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeaconCell.identifier, for: indexPath) as! BeaconCell
        let currentBeacon = Instances.beaconScanner.lastFullScan[indexPath.row]
        let distance = currentBeacon.distance
        
        cell.pointLbl.text = currentBeacon.nomeLuogo
//        cell.logLabel.text = "Mt: \(String(format: "%.2f", distance))\nRSSI: \(currentBeacon.CLProximity)\ntimestamp: \(DateUtility.getCurrentTime())"
        
//        #if DEBUG
//        cell.pointLbl.text = "(\(String(format: "%.2f", distance))m) " + currentBeacon.nomeLuogo
//        #else
//            cell.pointLbl.text = currentBeacon.nomeLuogo
//        #endif
        
        cell.configureView(beaconDistance: distance)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBeacon = Instances.beaconScanner.lastFullScan[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "placeInfoVC") as! PlaceInfoViewController
        controller.selectedIndex = indexPath.row //pass selected cell index to next view.
        controller.selectedTitle = currentBeacon.nomeLuogo
        controller.fullBeaconScan = currentBeacon
        if Instances.beaconScanner.idStanzePreferiti.contains(currentBeacon.idLuogo) {
            controller.isPreferito = true
        } else {
            controller.isPreferito = false
        }
        navigationItem.backButtonTitle = "Indietro"
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension StartViewController: ViewControllerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}
