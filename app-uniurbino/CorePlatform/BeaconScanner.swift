//
//  BeaconScanner.swift
//  app-uniurbino
//
//  Created by Be Ready Software on 17/02/23.
//

import UIKit
import CoreLocation

protocol ViewControllerDelegate {
    func updateTableView()
}

protocol SettingsDelegate {
    func authorizedAlways(_ isAuthorizedAlways: Bool)
}

class BeaconScanner: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var startDelegate: ViewControllerDelegate?
    var puntiDelegate: ViewControllerDelegate?
    var settingsDelegate: SettingsDelegate?
    
    var isScannerRunning = false
    
    var idStanzePreferiti = [String]()  // Array di idStanza che sono tra i preferiti
    var preferiti: [FavouriteModel] = [FavouriteModel]() { // Le stanze tra i preferiti
        didSet { // Aggiorno idStanzePreferiti, dove ci sono solo le stringhe degli idStanza dei preferiti
            idStanzePreferiti = []
            for preferito in preferiti {
                if let idStanza = preferito.idStanza {
                    idStanzePreferiti.append(idStanza)
                }
            }
            puntiDelegate?.updateTableView()
        }
    }
    
    var beaconRegion: CLBeaconRegion!
    var beaconConst: CLBeaconIdentityConstraint?
    
    // Ultima scansione CLBeacons
    var lastScanBeacons = [CLBeacon]()
    // Ultima scansione CLBeacons trasformati in oggetti univoci FullBeaconScan (con idLuogo)
    var lastFullScan = [FullBeaconScan]()
    
    // All'indice zero ci sarà l'array di beacon più longevo
//    var lastTenScans = [[FullBeaconScan]]()
//    var allScannedBeacons = [FullBeaconScan]()
    // Beacons scansionati, i quali sono stati sottoposti alla media delle ultime 20 rilevazioni
//    var averagedBeacons = [FullBeaconScan]()
    var uuid = ""
    var notificationsSent = [NotificationSent]() {
        didSet {
            let notificationsToSave = NotificationModel(notificationsSent: notificationsSent, snoozedBeacons: snoozedBeacons)
            UserSettingsManager.sharedInstance.saveNotifications(notificationsToSave)
        }
    }
    var snoozedBeacons = [SnoozedBeacon]() {
        didSet {
            let notificationsToSave = NotificationModel(notificationsSent: notificationsSent, snoozedBeacons: snoozedBeacons)
            UserSettingsManager.sharedInstance.saveNotifications(notificationsToSave)
        }
    }
    
    var palazzi = UserSettingsManager.sharedInstance.getAllPalazzi()
    
    var delayOneHour: UNNotificationAction!
    var delayThreeHours: UNNotificationAction!
    var delayOneDay: UNNotificationAction!
    var delayCategory: UNNotificationCategory!
    
    func askPreferiti(){
        guard let idUtente = UserSettingsManager.sharedInstance.getSavedUser()?.id else { return }
        BeaconService.getPreferiti(idUtente: String(idUtente), completion: { result in
            self.preferiti = result
        }, completionError: { error in
            // Se i preferiti sono vuoti l'API ci torna 404
            guard error.statusCode != 404 else {
                self.preferiti = []
                return
            }
            // Tolta la gestione dell'errore per evitare l'alert in assenza di connessione
//            self.manageErrorOnTopViewController(error: error)
        })
    }
    
    func manageErrorOnTopViewController(error: ApiError) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.manageApiError(error: error)
        }
    }
    
    func initializeScanner() {
        self.palazzi = UserSettingsManager.sharedInstance.getAllPalazzi()
        guard let palazzi, !palazzi.isEmpty else {
            Logger.log.error("Array dei palazzi vuoto")
            AlertView.ok(title: "Attenzione!", message: "Si è verificato durante il recupero delle aule, se il problema persiste contattare l'assistenza", completed: nil)
            return
        }
        guard isScannerRunning == false else { return }
        
        isScannerRunning = true
        
        let savedNotifications = UserSettingsManager.sharedInstance.getNotifications()
        notificationsSent = savedNotifications.notificationsSent
        snoozedBeacons = savedNotifications.snoozedBeacons
        
        
        locationManager.delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        
        guard let uuid = palazzi.first?.luoghi?.first?.uuid else { return }
        self.uuid = uuid
        beaconConst = CLBeaconIdentityConstraint(uuid: UUID(uuidString: uuid)!)
        guard let beaconConst else { return }
        beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConst, identifier: "UniUrb")
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = false
        
        #if DEBUG
            locationManager.showsBackgroundLocationIndicator = false
        #endif
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startRangingBeacons(satisfying: beaconConst)
        
        locationManager.startMonitoringSignificantLocationChanges()
        delayOneHour = UNNotificationAction(identifier: "delayOneHour", title: "Silenzia aula per un'ora")
        delayThreeHours = UNNotificationAction(identifier: "delayThreeHours", title: "Silenzia aula per tre ore")
        delayOneDay = UNNotificationAction(identifier: "delayOneDay", title: "Silenzia aula per un giorno")
        delayCategory = UNNotificationCategory(identifier: "delayCategory", actions: [delayOneHour, delayThreeHours, delayOneDay], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([delayCategory])
        
    }
    
    // Stop quando l'app entra in background
    func stopScanner() {
        
        isScannerRunning = false
        
        let rangingConstraintsToStop = locationManager.rangedBeaconConstraints
        rangingConstraintsToStop.forEach({locationManager.stopRangingBeacons(satisfying: $0)})
        let regionsToStop = locationManager.monitoredRegions
        regionsToStop.forEach({locationManager.stopMonitoring(for: $0)})
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconConst {
            locationManager.startRangingBeacons(satisfying: beaconConst)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside, let beaconConst {
            locationManager.startRangingBeacons(satisfying: beaconConst)
        }
        
        updateTableViews()
    }
    
    // Ogni misurazione singola (singolo scan di tutti i beacon)
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        Logger.log.verbose("Scanned beacons: \(beacons)")
        guard let palazzi, palazzi.count > 0 else {return}
        
        lastScanBeacons = beacons.sorted(by: { beacon1, beacon2 in
            if beacon2.accuracy < 0 {
                return true
            } else {
                return beacon1.accuracy < beacon2.accuracy
            }
        })
        
        // Elaboro beacon ultima scansione, con tutti i dati
        lastFullScan = []
        for lastScanBeacon in lastScanBeacons {
            guard
                let palazzoCorrente = palazzi.first(where: {$0.majorNumber == lastScanBeacon.major.intValue}),
                let luogoCorrente = palazzoCorrente.luoghi!.first(where: {$0.minorNumber == lastScanBeacon.minor.intValue}),
                lastScanBeacon.rssi != 0
            else {
                updateTableViews()
                return
            }
            lastFullScan.append(FullBeaconScan(
                lastAccuracy: lastScanBeacon.accuracy,
                averageAccuracy: nil,
                rssi: lastScanBeacon.rssi,
                distance: BeaconScanner.getDistance(rssi: Double(lastScanBeacon.rssi)),
                idLuogo: luogoCorrente.idLuogo!,
                nomeLuogo: luogoCorrente.nome!,
                minor: lastScanBeacon.minor.intValue,
                major: lastScanBeacon.major.intValue,
                uuid: uuid)
            )
        }
        
//        lastTenScans.append(lastFullScan)
//        lastTenScans = lastTenScans.suffix(2)
        
//        allScannedBeacons = []
        
        // Dentro allScannedBeacons abbiamo tutti i beacon di tutte le scansioni, per poi estrarre i singoli e fare la media
//        lastTenScans.forEach({allScannedBeacons.append(contentsOf: $0)})
        
        
        // Prendo i beacon unici delle ultime tot scansioni
//        var uniqueBeacons = [FullBeaconScan]()
//        for scannedBeacon in allScannedBeacons {
//            if !uniqueBeacons.contains(where: {$0.idLuogo == scannedBeacon.idLuogo}) {
//                uniqueBeacons.append(scannedBeacon)
//            }
//        }
        
        
//        averagedBeacons = []
//        averagedBeacons = lastFullScan

        // Per ogni beacon singolo rilevato nelle ultime tot rilevazioni
//        for uniqueBeacon in uniqueBeacons {
//            var accuracies = [Int]()
//            // Per ogni beacon scansionato
//            for singleScan in allScannedBeacons {
//                if uniqueBeacon.idLuogo == singleScan.idLuogo {
//                    if singleScan.CLProximity != -1 && singleScan.CLProximity != 0{
//                        accuracies.append(singleScan.CLProximity)
//                    }
//                }
//            }
//
//            if accuracies.count == 0{return}
//            let sum = accuracies.reduce(0, +)
//            let average = sum / accuracies.count
//            let averageAccuracy = average
//            var averagedBeacon = uniqueBeacon
//            let distance = getDistance(rssi: Double(averageAccuracy))
//            averagedBeacon.averageAccuracy = distance
//            // Mostro il beacon solo se è stato rilevato in almeno un quinto delle scansioni, e se l'accuracy è minore di 20 metri
//            let numberOfScans = lastTenScans.count
////            if accuracies.count > numberOfScans / 5, averageAccuracy < 20 {
////                averagedBeacons.append(averagedBeacon)
////            }
////
//            if distance > 0 {
//                averagedBeacons.append(averagedBeacon)
//            }
//
        
        // GESTIONE NOTIFICA SENZA MEDIA DI RILEVAZIONI (PER VEDERE VECCHIO FUNZIONAMENTO CERCARE SU VECCHI COMMIT)
            // Controllo se ho inviato una notifica negli ultimi 5 secondi
            var justSentANotification = false
            if let lastSentNotification = notificationsSent.last {
                if abs(lastSentNotification.sentDate.timeIntervalSinceNow) < 5 {
                    justSentANotification = true
                }
            }

            let notificationSettings = UserSettingsManager.sharedInstance.getNotificationSettings()
            let calendar = UserSettingsManager.sharedInstance.getSavedCalendar()
            let isUniUrbUser = UserSettingsManager.sharedInstance.getSavedUser()?.isUniurbUser ?? false

            let notificheAttivePerTutteLeAule = notificationSettings.tutteLeAule
            let notificheAttivePerAuleConImpegni = notificationSettings.auleConImpegni
            let notificheAttivePerAulePreferite = notificationSettings.aulePreferite


            // Tutta la gestione relativa all'invio della notifica
            if !justSentANotification {
                for beacon in lastFullScan {
                    if beacon.distance < 3 {
                        let isBeaconPreferito = idStanzePreferiti.contains(beacon.idLuogo)
                        var isBeaconInCalendarNow = false
                        var dettaglioEvento: String? = nil

                        if isUniUrbUser,
                           let eventoCalendario = calendar?.first(where: {$0.idStanza == beacon.idLuogo}),
                           let stringaDataInizio = eventoCalendario.inizio,
                           let stringaDataFine = eventoCalendario.fine,
                           let dataInizio = DateUtility.getDateAndTime(date: stringaDataInizio),
                           let dataFine = DateUtility.getDateAndTime(date: stringaDataFine),
                           let dataInizioMeno15 = Calendar.current.date(byAdding: DateComponents(minute: -15), to: dataInizio),
                           let dataFineMeno15 = Calendar.current.date(byAdding: DateComponents(minute: -15), to: dataFine)
                        {
                            if Date() >= dataInizioMeno15, Date() <= dataFineMeno15 {
                                isBeaconInCalendarNow = true
                                if let dettagli = eventoCalendario.dettagli {
                                    dettaglioEvento = dettagli
                                }
                            }
                        }

                        // Il beacon è nell'orario dell'evento del calendario e sono attive notifiche calendario
                        var inCalendarAndAllowed = false
                        if isBeaconInCalendarNow, notificheAttivePerAuleConImpegni {
                            inCalendarAndAllowed = true
                        }

                        // Il beacon è tra i preferiti e sono attive le notifiche per preferiti
                        var isFavouriteAndAllowed = false
                        if isBeaconPreferito, notificheAttivePerAulePreferite {
                            isFavouriteAndAllowed = true
                        }

                        // Se non ci sono motivi per inviare la notifica, esco dal ciclo
                        if !inCalendarAndAllowed, !isFavouriteAndAllowed, !notificheAttivePerTutteLeAule {
                            break
                        }

                        // Controllo se il beacon è snoozed e ancora non è passato l'intervallo
                        var isBeaconSnoozed = false
                        for snoozedBeacon in snoozedBeacons {
                            if snoozedBeacon.idLuogo == beacon.idLuogo,
                               abs(snoozedBeacon.snoozedDate.timeIntervalSinceNow) < (Double(snoozedBeacon.snoozeDuration.rawValue) * 3600)
                            {
                                isBeaconSnoozed = true
                            }
                        }


                        // Controllo se non ho già inviato una notifica per quel beacon nell'ultimo minuto, o se il beacon è stato silenziato
                        if !isBeaconSnoozed, !notificationsSent.contains(where: {$0.idLuogo == beacon.idLuogo && abs($0.sentDate.timeIntervalSinceNow) < 60 }) {
                            if isBeaconSnoozed {
                                snoozedBeacons.removeAll(where: {$0.idLuogo == beacon.idLuogo})
                            }
                            var titoloNotifica = "Sei vicino ad un'aula!"
                            let sottotitoloNotifica = beacon.nomeLuogo
                            var corpoNotifica: String?
                            if inCalendarAndAllowed {
                                titoloNotifica = "Evento nelle vicinanze!"
                                corpoNotifica = dettaglioEvento
                            }
                            postNotification(title: titoloNotifica, subtitle: sottotitoloNotifica, body: corpoNotifica, delay: true, idLuogo: beacon.idLuogo)
                            notificationsSent.append(NotificationSent(idLuogo: beacon.idLuogo, sentDate: Date()))
                        }
                    }
                }
            }
//        }
//
//        averagedBeacons.sort(by: { firstBeacon, secondBeacon in
//            if let firstAccuracy = firstBeacon.averageAccuracy, let secondAccuracy = secondBeacon.averageAccuracy {
//                return firstAccuracy < secondAccuracy
//            } else {
//                return false
//            }
//        })
        
        
        // Arrotondamento ad intero
//        for (i, beacon) in averagedBeacons.enumerated() {
//            if let averageAccuracy = beacon.averageAccuracy, averageAccuracy > 1 {
//                averagedBeacons[i].averageAccuracy = averageAccuracy.rounded()
//            }
//        }
        
//        Logger.log.verbose("Averaged beacons: \(averagedBeacons)")
        
        updateTableViews()
        
        // Se app in background chiedo la location, altrimenti l'app diventa suspended e il ranging si stoppa
        if UIApplication.shared.applicationState == .background {
            locationManager.requestLocation()
        }
        
    }
    
    static func getDistance(rssi: Double)-> Double{
        let txPower = -65.0 //hard coded power value. Usually ranges between -59 to -65
        
        if (rssi == 0) {
            return -1.0;
        }
        let ratio = rssi*1.0/txPower;
        print("RATIO: \(ratio)")

        if (ratio < 1.0) {
            return pow(ratio,10);
        }
        else {
            let distance = (0.89976)*pow(ratio,7.7095) + 0.111;
            return distance;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updating location")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateTableViews() {
        startDelegate?.updateTableView()
        puntiDelegate?.updateTableView()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let beaconConst, manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startRangingBeacons(satisfying: beaconConst)
        }
        if manager.authorizationStatus == .authorizedAlways {
            settingsDelegate?.authorizedAlways(true)
        } else {
            settingsDelegate?.authorizedAlways(false)
            locationManager.requestAlwaysAuthorization()
        }
    }
}


extension BeaconScanner: UNUserNotificationCenterDelegate {
    func postNotification(title: String, subtitle: String, body: String? = nil, delay: Bool = false, idLuogo: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        if let body {
            content.body = body
        }
        content.sound = UNNotificationSound.default
        content.userInfo = ["idLuogoBeacon": idLuogo]
        // Per gestire lo snooze della notifica
        if delay {
            content.categoryIdentifier = "delayCategory"
        }
        let request = UNNotificationRequest(identifier: idLuogo, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["idLuogoBeacon"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")

            case "delayOneHour":
                snoozedBeacons.append(SnoozedBeacon(idLuogo: customData, snoozedDate: Date(), snoozeDuration: .oneHour))
            case "delayThreeHours":
                snoozedBeacons.append(SnoozedBeacon(idLuogo: customData, snoozedDate: Date(), snoozeDuration: .threeHours))
            case "delayOneDay":
                snoozedBeacons.append(SnoozedBeacon(idLuogo: customData, snoozedDate: Date(), snoozeDuration: .oneDay))
                
            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
    
    
}
