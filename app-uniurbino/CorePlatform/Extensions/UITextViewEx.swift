//
//  UITextViewEx.swift
//  Vivibanca
//
//  Created by Lorenzo on 22/03/22.
//

import Foundation
import UIKit

class textViewWithDone: UITextView {
    
    @IBInspectable var doneAccessory: Bool = true{
        didSet {
            if doneAccessory{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    
    
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = false

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done".customLocalized, style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .white
        doneToolbar.barTintColor = .black
        let items = [flexSpace, done, flexSpace]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    

}


extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
