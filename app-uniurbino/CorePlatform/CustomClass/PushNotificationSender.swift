//
//  PushNotificationSender.swift
//  app-uniurbino
//
//  Created by Be Ready Software on 23/02/23.
//

import Foundation

class PushNotificationSender {
    // Send an instant push notification to the device itself
    static func sendPushNotification(title: String, body: String) {
        guard let pushIdentifierString = UserSettingsManager.sharedInstance.pushIdentifierString else { return }
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : pushIdentifierString,
                                           "notification" : ["title" : title, "body" : body],
                                           "content_available": true
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA6PT4CII:APA91bG8tgwhaZItJxyefzbDAoRN9fQGNVdRUW7-uxVvFGRZ5-SyW6nAgNBShg7z7mVWQMg5SUEXYT5YTt2cDu4JecVI8jBp-Y8yXXwiv0bBKWaDotsgMFT-wJ9NjyN8DL1JfNH6PVT0", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
