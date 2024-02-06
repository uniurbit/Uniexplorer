//
//  PuntiViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 24/01/23.
//

import UIKit

class PuntiViewController: GenericVC {
    
    @IBOutlet var greetingTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var userPic: UIButton!
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()
    let userImage = UIImage(named: "Vector3")!
    let guestImage = UIImage(named: "Vector7")
    
    var beaconScanner: BeaconScanner!
    var buildingDetails = LuogoDetails()
    var calendar = UserSettingsManager.sharedInstance.getSavedCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Instances.beaconScanner.puntiDelegate = self
        Instances.beaconScanner.askPreferiti()
        
        
        
        userPic.isAccessibilityElement = true
        userPic.accessibilityLabel = "Profilo"
        userPic.imageView?.contentMode = .scaleAspectFit
        
        initView()
        
    }
    
    // MARK: - Init
    private func initView(){
        if user != nil {
            setupForUser()
        } else {
            setupForGuest()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BeaconCell.nibName, forCellReuseIdentifier: BeaconCell.identifier)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupForUser() {
        userPic.tag = 0
        addBtn.tag = 0
        if let nome = UserSettingsManager.sharedInstance.getSavedUser()?.nome {
            self.navigationItem.title = "Ciao, " + nome + "!"
        } else {
            self.navigationItem.title = "Ciao!"
        }
        NSLayoutConstraint.activate([
            userPic.widthAnchor.constraint(equalToConstant: 44),
            userPic.heightAnchor.constraint(equalToConstant: 44)
        ])
        FileUtility.downloadImageBtnFromUrl(imgUrl: user!.imgUrl, btn: userPic, placeholderImg: userImage)
    }
    
    //setting up for guest
    func setupForGuest() {
        userPic.setImage(guestImage, for: .normal)
        userPic.tag = 1
        addBtn.tag = 1
        self.navigationItem.title = "Ciao, " + "Guest" + "!"
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
    
    // MARK: - Action
    
    @IBAction func showProfileVC(_ sender: UIButton) {
        goToProfileScreen()
    }
    
    @IBAction func showAddVC(_ sender: UIButton) {
        goToAddScreen()
    }
    
}

extension PuntiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let calendar else { return 1 }
        if calendar.isEmpty{
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return Instances.beaconScanner.preferiti.count
        }else{
            return calendar?.count ?? 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeaconCell.identifier, for: indexPath) as! BeaconCell
        
        if indexPath.section == 0{
            cell.pointLbl.text = Instances.beaconScanner.preferiti[indexPath.row].nomeStanza
            let idStanza = Instances.beaconScanner.preferiti[indexPath.row].idStanza
            
            // Se non sono attivi i beacon, rendo le righe grigie
            if let foundBeacon = Instances.beaconScanner.lastFullScan.first(where: {
                    $0.uuid == Instances.beaconScanner.preferiti[indexPath.row].uuid &&
                    $0.major == Instances.beaconScanner.preferiti[indexPath.row].majorNumber &&
                    $0.minor == Instances.beaconScanner.preferiti[indexPath.row].minorNumber
            }) {
                cell.genericView.backgroundColor = UIColor.white
                cell.configureView(beaconDistance: BeaconScanner.getDistance(rssi: Double(foundBeacon.rssi)))
            } else {
                cell.genericView.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 31/255, alpha: 0.1)
                cell.configureView(beaconDistance: nil)
            }
        }else{
            guard let calendar else { return cell }
            
            cell.pointLbl.text = calendar[indexPath.row].nomeStanza
            let idStanza = calendar[indexPath.row].idStanza
            
            // Se non sono attivi i beacon, rendo le righe grigie
            if let foundBeacon = Instances.beaconScanner.lastFullScan.first(where: {
                $0.uuid == calendar[indexPath.row].uuid &&
                $0.major == calendar[indexPath.row].majorNumber &&
                $0.minor == calendar[indexPath.row].minorNumber
            }) {
                cell.genericView.backgroundColor = UIColor.white
                cell.configureView(beaconDistance: BeaconScanner.getDistance(rssi: Double(foundBeacon.rssi)))
            } else {
                cell.genericView.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 31/255, alpha: 0.1)
                cell.configureView(beaconDistance: nil)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "placeInfoVC") as! PlaceInfoViewController
        controller.selectedIndex = indexPath.row //pass selected cell index to next view.
        if indexPath.section == 0{
            controller.selectedTitle = Instances.beaconScanner.preferiti[indexPath.row].nomeStanza ?? ""
            //        controller.idStanza = buildingDetails[indexPath.row].idStanza ?? ""
            controller.fav = Instances.beaconScanner.preferiti[indexPath.row]
            controller.isPreferito = true
        }else{
            guard let calendar else { return }
            controller.selectedTitle = calendar[indexPath.row].nomeStanza ?? ""
            if Instances.beaconScanner.preferiti.contains(where: {
                $0.uuid == calendar[indexPath.row].uuid &&
                $0.majorNumber == calendar[indexPath.row].majorNumber &&
                $0.minorNumber == calendar[indexPath.row].minorNumber
            }){
                controller.isPreferito = true
            }else{
                controller.isPreferito = false
            }
            controller.calendar = calendar[indexPath.row]

            
        }

        navigationItem.backButtonTitle = "Indietro"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        myLabel.font = UIFont(name: "AtkinsonHyperlegible-Bold", size: 17)
        
        if section == 0{
            myLabel.text = "Punti di interesse"
        }else{
            myLabel.text = "Eventi di oggi"
        }
        
        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && Instances.beaconScanner.preferiti.isEmpty == true{
            return 0
        }else{
            return 40
        }
    }
    
}


extension PuntiViewController: ViewControllerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}
