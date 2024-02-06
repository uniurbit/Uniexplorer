//
//  CustomActivityItems.swift
//  Vivibanca
//
//  Created by Lorenzo on 01/04/22.
//

import Foundation
import LinkPresentation


class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String?
    var link: String?
    init(title: String, text: String?, link: String?) {
        self.title = title
        self.text = text
        self.link = link
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        
        metadata.iconProvider = NSItemProvider(object: UIImage(named: "pdfImage")!)
        return metadata
    }
    

}
