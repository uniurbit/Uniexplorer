//
//  UserSettingManager.swift
//  Plin
//
//  Created by Be Ready Software on 09/08/21.
//

import Foundation

class UserSettingsManager {
    
    static let sharedInstance : UserSettingsManager = {
        let instance = UserSettingsManager()
        return instance
    }()
    
    
    func getSavedCalendar() -> [EventoModel]? {
        guard let calendar = UserSettingsManager.sharedInstance.calendar, !calendar.isEmpty else {
            return nil
        }
        
        var savedCalendar = [EventoModel]()
        for calendar in calendar {
            if let data = calendar.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(EventoModel.self, from: data)
                    savedCalendar.append(model)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return savedCalendar
    }
    
    func saveCalendar(calendar: [EventoModel]?) {
        if let calendar {
            var newCategoryString = [String]()
            for calendar in calendar {
                newCategoryString.append(calendar.toJsonString())
            }
            UserSettingsManager.sharedInstance.calendar = newCategoryString

        }else{
            UserSettingsManager.sharedInstance.calendar = nil
        }
    }
    

    
    
    // Tutti i palazzi esistenti e scansionabili
    func getAllPalazzi() -> [PalazzoModel]? {
        guard let palazzi = UserSettingsManager.sharedInstance.allPalazzi, !palazzi.isEmpty else {
            return nil
        }
        
        var savedPalazzi = [PalazzoModel]()
        for palazzo in palazzi {
            if let data = palazzo.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(PalazzoModel.self, from: data)
                    savedPalazzi.append(model)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return savedPalazzi
    }
    
    func saveAllPalazzi(palazzi: [PalazzoModel]?) {
        if let palazzi {
            var newCategoryString = [String]()
            for palazzo in palazzi {
                newCategoryString.append(palazzo.toJsonString())
            }
            UserSettingsManager.sharedInstance.allPalazzi = newCategoryString

        }
    }


    func getSavedUser() -> UserModel? {
        guard let user = UserSettingsManager.sharedInstance.userModelString else {
            return nil
        }
        
        if let data = user.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(UserModel.self, from: data)
                return model
            } catch {
//                print(error.localizedDescription)
                print("The error is: \(String(describing: error))")
            }
        }
        return nil
    }
    
    func saveUser(user: UserModel?) {
        if let user = user {
            UserSettingsManager.sharedInstance.userModelString = user.toJsonString()
        }
        else {
            UserSettingsManager.sharedInstance.userModelString = nil
        }
    }
    
    
    func getNotifications() -> NotificationModel {
        guard let notifications = UserSettingsManager.sharedInstance.notifications else {
            return NotificationModel(notificationsSent: [], snoozedBeacons: [])
        }
        
        if let data = notifications.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(NotificationModel.self, from: data)
                return model
            } catch {
                print("The error is: \(String(describing: error))")
            }
        }
        return NotificationModel(notificationsSent: [], snoozedBeacons: [])
    }
    
    func saveNotifications(_ notificationModel: NotificationModel) {
        UserSettingsManager.sharedInstance.notifications = notificationModel.toJsonString()
    }
    
    func getNotificationSettings() -> NotificationSettingsModel {
        guard let notifications = UserSettingsManager.sharedInstance.notificationSettings else {
            return NotificationSettingsModel(tutteLeAule: true, auleConImpegni: true, aulePreferite: true)
        }
        
        if let data = notifications.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(NotificationSettingsModel.self, from: data)
                return model
            } catch {
                print("The error is: \(String(describing: error))")
            }
        }
        return NotificationSettingsModel(tutteLeAule: true, auleConImpegni: true, aulePreferite: true)
    }
    
    func saveNotificationSettings(_ notificationSettingsModel: NotificationSettingsModel) {
        UserSettingsManager.sharedInstance.notificationSettings = notificationSettingsModel.toJsonString()
    }
    

    var allPalazzi: [String]? {
        set{
            UserDefaults.standard.set(newValue, forKey: "allPalazzi")
        }
        get{
            return UserDefaults.standard.object(forKey: "allPalazzi") as? [String]
        }
    }
    
    private var userModelString: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "userModelString")
        }
        get{
            return UserDefaults.standard.string(forKey: "userModelString")
        }
    }
    
    var pushIdentifierString: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "pushIdentifierString")
        }
        get{
            return UserDefaults.standard.string(forKey: "pushIdentifierString")
        }
    }
    
    // Here I save notifications sent and snoozed beacons
    private var notifications: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "notifications")
        }
        get{
            return UserDefaults.standard.string(forKey: "notifications")
        }
    }
    
    
    var calendar: [String]? {
        set{
            UserDefaults.standard.set(newValue, forKey: "calendar")
        }
        get{
            return UserDefaults.standard.object(forKey: "calendar") as? [String]
        }
    }


    // User notification settings for aule, preferiti, calendario
    private var notificationSettings: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "notificationSettings")
        }
        get{
            return UserDefaults.standard.string(forKey: "notificationSettings")
        }
    }
    
    var backgroundScanSetting: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "backgroundScanSetting")
        }
        get {
            return UserDefaults.standard.bool(forKey: "backgroundScanSetting")
        }
    }
    
}

struct NotificationSettingsModel: Codable {
    var tutteLeAule: Bool
    var auleConImpegni: Bool
    var aulePreferite: Bool
}
