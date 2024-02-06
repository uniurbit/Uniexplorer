//
//  NotificationModel.swift
//  app-uniurbino
//
//  Created by Be Ready Software on 16/02/23.
//

import Foundation

struct NotificationModel: Codable {
    var notificationsSent: [NotificationSent]
    var snoozedBeacons: [SnoozedBeacon]
}

struct NotificationSent: Codable {
    var idLuogo: String
    var sentDate: Date
}

struct SnoozedBeacon: Codable {
    var idLuogo: String
    var snoozedDate: Date
    var snoozeDuration: SnoozeDuration
}

enum SnoozeDuration: Int, Codable {
    case oneHour = 1
    case threeHours = 3
    case oneDay = 24
}
