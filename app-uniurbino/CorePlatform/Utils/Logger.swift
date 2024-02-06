//
//  Logger.swift
//  StrutturaApp
//
//  Created by Be Ready Software on 20/02/23.
//

import Foundation
import SwiftyBeaver

class Logger {
    
    static let log: SwiftyBeaver.Type = {
        let log = SwiftyBeaver.self
        
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        let cloud = SBPlatformDestination(appID: "Qxnq7n", appSecret: "kdulceRbejpifnn8up9sluCfuduvfslC", encryptionKey: "edm8rdAda3ndihtsncrakvs2b35aWfaa") // to cloud

        #if DEBUG
        log.addDestination(console)
//        log.addDestination(cloud)
        #endif
        
        return log
    }()
    
}
