//
//  UITableViewEx.swift
//  ITWA
//
//  Created by Manuela on 04/05/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import UIKit

extension UITableView {
    
    func getCaptionLabel() -> UILabel {
        let caption = UILabel(frame: CGRect(x: 16, y: 0, width: self.bounds.width, height: self.sectionHeaderHeight))
        caption.textAlignment = .left
        caption.textColor = UIColor.white
        caption.backgroundColor = UIColor.clear
        return caption
    }
    
}


