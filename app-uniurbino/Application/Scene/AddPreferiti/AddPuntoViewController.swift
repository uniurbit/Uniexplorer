//
//  AddPuntoViewController.swift
//  app-uniurbino
//
//  Created by Maria Smirnova on 07/02/23.
//

import UIKit

class AddPuntoViewController: UIViewController {
    
    var isUser: Bool?
    var points = [FavouriteModel]()
    
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    
  
    @IBOutlet weak var nomeEdificioButton: UIButton!
    @IBOutlet weak var nomeAulaButton: UIButton!
    
    @IBOutlet weak var nomeEdificioLabel: UILabel!
    @IBOutlet weak var nomeAulaLabel: UILabel!
    
    let palazzi = UserSettingsManager.sharedInstance.getAllPalazzi()
    var stanze = [String]()
    
    var palazziActions = [UIAction]()
    var stanzeActions = [UIAction]()
    
    var idEdificioSelected: String?
    var idStanzaSelected: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        guard let palazzi else {return}
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.accessibilityLabel = "Bottone indietro"
        
        profileBtn.isAccessibilityElement = true
        profileBtn.accessibilityLabel = "Profilo"
        profileBtn.imageView?.contentMode = .scaleAspectFit
        if let user = UserSettingsManager.sharedInstance.getSavedUser(){
            FileUtility.downloadImageBtnFromUrl(imgUrl: user.imgUrl, btn: profileBtn, placeholderImg: UIImage(named: "Vector3")!)
        }
        for palazzo in palazzi {
            let nomePalazzo = palazzo.nome ?? ""
            let action = UIAction(title: nomePalazzo) { [self] _ in
                nomeEdificioLabel.text = nomePalazzo
                idEdificioSelected = palazzo.idPalazzo
                reloadAulaMenu(palazzoSelezionato: palazzo)
                // Svuoto aula se ho cambiato palazzo
                nomeAulaLabel.text = "Nome aula"
                idStanzaSelected = nil
            }
            palazziActions.append(action)
        }
        
        
        nomeEdificioButton.showsMenuAsPrimaryAction = true
        nomeEdificioButton.menu = UIMenu(children: palazziActions)

        
    }
    
    func reloadAulaMenu(palazzoSelezionato: PalazzoModel) {
        guard let stanze = palazzoSelezionato.luoghi else { return }
        stanzeActions = []
        for stanza in stanze {
            let nomeStanza = stanza.nome ?? ""
            let action = UIAction(title: nomeStanza) { _ in
                self.nomeAulaLabel.text = nomeStanza
                self.idStanzaSelected = stanza.idLuogo
            }
            stanzeActions.append(action)
        }
        nomeAulaButton.showsMenuAsPrimaryAction = true
        nomeAulaButton.menu = UIMenu(children: stanzeActions)
        
    }
    
    
    func addNewPointInCell(point: FavouriteModel){
        points.append(point)
        print(points.count)
    }

    func goToProfileScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(identifier: "profileVC") as! ProfileTableViewController
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func openProfile(_ sender: UIButton) {
        if sender.tag == 0 {
            self.isUser = true
            goToProfileScreen()
            print("\(sender.tag)" + " this is tag")
        } else if sender.tag == 1 {
            self.isUser = false
            goToProfileScreen()
            print("\(sender.tag)" + " this is tag")
        }
    }
    
    @IBAction func addNewPoint(_ sender: Any) {
        guard let idStanzaSelected, let idUtente = UserSettingsManager.sharedInstance.getSavedUser()?.id else { return }
        guard !Instances.beaconScanner.idStanzePreferiti.contains(idStanzaSelected) else {
            AlertView.ok(controller: self, title: "Attenzione", message: "La stanza è già tra i preferiti", completed: nil)
            return
        }
        guard let palazzi = palazzi,
              let i = palazzi.firstIndex(where: { $0.luoghi?.contains { $0.idLuogo == idStanzaSelected } ?? false }),
              let luogo = palazzi[i].luoghi?.first(where: {$0.idLuogo == idStanzaSelected})
        else { return }
        guard let uuid = luogo.uuid, let major = luogo.majorNumber, let minor = luogo.minorNumber
        else {return}
        BeaconService.addLuogo(idUtente: String(idUtente), uuid: uuid, major: major, minor: minor, completion: { result in
            self.hideActivityIndicator()
            Instances.beaconScanner.askPreferiti()
            self.navigationController?.popViewController(animated: true)
        }, completionError: { error in
            self.hideActivityIndicator()
            self.manageApiError(error: error)
        })
    }
}

extension AddPuntoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
