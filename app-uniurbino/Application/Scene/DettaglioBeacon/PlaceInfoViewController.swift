//
//  PlaceInfoViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 23/01/23.
//

import UIKit


class PlaceInfoViewController: GenericVC {
    
    
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    var isPreferito: Bool = false {
        didSet {
            if addBtn != nil {
                setupActionBtn()
            }
        }
    }
    
    
    var user = UserSettingsManager.sharedInstance.getSavedUser()
    var selectedIndex = 0
    var selectedTitle = ""
    var buildings = [FavouriteModel]()
    var fav: FavouriteModel!
    var calendar: EventoModel!
    var fullBeaconScan: FullBeaconScan!
    var buildingDetails = LuogoDetails()
    let userImage = UIImage(named: "Vector3")
    let guestImage = UIImage(named: "Vector7")
    let deleteImg = UIImage(systemName: "trash.fill")
    let addImg = UIImage(named: "Vector8")
    var negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedTitle
        textView.text = nil
        negativeSpacer.width = -5
        navigationItem.largeTitleDisplayMode = .never
        if let fav{
            guard let uuid = fav.uuid, let major = fav.majorNumber, let minor = fav.minorNumber else {return}
            showDetails(uuid: uuid, major: String(major), minor: String(minor))
        }else if let calendar{
            guard let uuid = calendar.uuid, let major = calendar.majorNumber, let minor = calendar.minorNumber else {return}
            showDetails(uuid: uuid, major: String(major), minor: String(minor))
        }else if let fullBeaconScan{
            let uuid = fullBeaconScan.uuid
            let major = fullBeaconScan.major
            let minor = fullBeaconScan.minor
            showDetails(uuid: uuid, major: String(major), minor: String(minor))
        }
        profileBtn.isAccessibilityElement = true
        profileBtn.accessibilityLabel = "Profilo"
        
        if user != nil {
            setupForUser()
        } else {
            setupForGuest()
        }
        setupActionBtn()
        
    }
    
    func showDetails(uuid: String, major: String, minor: String){
        showActivityIndicator()
        BeaconService.getLuogo(uuid: uuid, major: major, minor: minor, completion: { result in
            self.hideActivityIndicator()
            self.buildingDetails = result
            self.handleDetails(result)
        }, completionError: { error in
            self.hideActivityIndicator()
            self.manageApiError(error: error)
        })
    }
    
    func removeLuogo(uuid: String, major: Int, minor: Int) {
        guard let idUtente = UserSettingsManager.sharedInstance.getSavedUser()?.id else { return }
        BeaconService.deleteLuogo(idUtente: String(idUtente), uuid: uuid, major: major, minor: minor, completion: { result in
            Instances.beaconScanner.askPreferiti()
            self.isPreferito = false
            AlertView.ok(controller: self, title: "Aula eliminata dai preferiti", message: nil, completed: nil)
        }, completionError: { error in
            self.hideActivityIndicator()
            self.manageApiError(error: error)
        })
    }
    
    func addToPreferiti(uuid: String, major: Int, minor: Int) {
        guard let idUtente = UserSettingsManager.sharedInstance.getSavedUser()?.id else { return }
        BeaconService.addLuogo(idUtente: String(idUtente), uuid: uuid, major: major, minor: minor, completion: { result in
            Instances.beaconScanner.askPreferiti()
            self.isPreferito = true
            AlertView.ok(controller: self, title: "Aula aggiunta ai tuoi preferiti", message: nil, completed: nil)
        }, completionError:  { error in
            self.hideActivityIndicator()
            self.manageApiError(error: error)
        })
    }
    
    func setupActionBtn() {
        if isPreferito == true {
            addBtn.backgroundColor = .systemRed
            addBtn.setTitle("Rimuovi dai preferiti", for: .normal)
            addBtn.setImage(deleteImg, for: .normal)
        } else if isPreferito == false {
            addBtn.backgroundColor = .systemBlue
            addBtn.setTitle("Aggiungi", for: .normal)
            addBtn.setImage(addImg, for: .normal)
        }
    }
    
    func setupForUser() {
        profileBtn.setImage(userImage, for: .normal)
        profileBtn.tag = 0
        addBtn.tag = 0
        
        FileUtility.downloadImageBtnFromUrl(imgUrl: user!.imgUrl, btn: profileBtn, placeholderImg: UIImage(named: "Vector3")!)
    }
    func setupForGuest() {
        profileBtn.setImage(guestImage, for: .normal)
        profileBtn.tag = 1
        addBtn.tag = 1
        addBtn.isHidden = true
    }
    func goToProfileScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(identifier: "profileVC") as! ProfileTableViewController
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func handleDetails(_ details: LuogoDetails) {
        guard let testo = details.testo else { return }
        let headerHTML = """
                <head>
                <link href="https://fonts.cdnfonts.com/css/sf-pro-display" rel="stylesheet">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                    <style>
                        body {
                            font-family: "SF Pro Display";
                            font-size: 16px;
                        }
                    </style>
                </head>
                <body>
                """
        let htmlText = headerHTML + testo
        textView.attributedText = htmlText.htmlToAttributedString
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: testo.htmlToString)
        }
    }
    
    
    @IBAction func showProfileVC(_ sender: UIButton) {
        goToProfileScreen()
    }
    @IBAction func luogoAction(_ sender: UIButton) {
        if isPreferito == true {
            if let fav{
                guard let uuid = fav.uuid, let major = fav.majorNumber, let minor = fav.minorNumber else {return}
                removeLuogo(uuid: uuid, major: major, minor: minor)
            }else if let calendar{
                guard let uuid = calendar.uuid, let major = calendar.majorNumber, let minor = calendar.minorNumber else {return}
                removeLuogo(uuid: uuid, major: major, minor: minor)
            }else if let fullBeaconScan{
                let uuid = fullBeaconScan.uuid
                let major = fullBeaconScan.major
                let minor = fullBeaconScan.minor
                removeLuogo(uuid: uuid, major: major, minor: minor)
            }
        } else if isPreferito == false {
            if let fav{
                guard let uuid = fav.uuid, let major = fav.majorNumber, let minor = fav.minorNumber else {return}
                addToPreferiti(uuid: uuid, major: major, minor: minor)
            }else if let calendar{
                guard let uuid = calendar.uuid, let major = calendar.majorNumber, let minor = calendar.minorNumber else {return}
                addToPreferiti(uuid: uuid, major: major, minor: minor)
            }else if let fullBeaconScan{
                let uuid = fullBeaconScan.uuid
                let major = fullBeaconScan.major
                let minor = fullBeaconScan.minor
                addToPreferiti(uuid: uuid, major: major, minor: minor)
            }
        }
    }
}
