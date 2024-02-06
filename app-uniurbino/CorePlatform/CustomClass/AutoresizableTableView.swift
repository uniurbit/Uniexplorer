//
//  AutoresizableTableView.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit

class AutoResizeTableViewClass: UITableView {
    override var intrinsicContentSize: CGSize {
       self.layoutIfNeeded()
       return self.contentSize
    }

    override var contentSize: CGSize {
       didSet{
           self.invalidateIntrinsicContentSize()
       }
    }

    override func reloadData() {
       super.reloadData()
       self.invalidateIntrinsicContentSize()
    }
}
