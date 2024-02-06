//
//  LuogoTableViewCell.swift
//  app-uniurbino
//
//  Created by Be Ready Software on 17/02/23.
//

import UIKit

class LuogoTableViewCell: UITableViewCell {
    
    
    @IBOutlet var logLabel: UILabel!
    @IBOutlet var pointLbl: UILabel!
    
    
    //PROXIMITY
    @IBOutlet weak var unknownView: UIView!
    @IBOutlet weak var farView: UIView!
    @IBOutlet weak var nearView: UIView!
    @IBOutlet weak var immediateView: UIView!
    
    let onColor = UIColor.black
    let offColor = UIColor.systemGray5
    
    func configureViewForAccuracy(_ accuracy: Int) {
        switch accuracy {
        case  4...: //2 tacche .far:
                unknownView.backgroundColor = onColor
                farView.backgroundColor = onColor
                nearView.backgroundColor = offColor
                immediateView.backgroundColor = offColor
        case 2...4: //3 tacche .near:
                unknownView.backgroundColor = onColor
                farView.backgroundColor = onColor
                nearView.backgroundColor = onColor
                immediateView.backgroundColor = offColor
        case 0...2: //4 tacche .immediate:
               unknownView.backgroundColor = onColor
               farView.backgroundColor = onColor
               nearView.backgroundColor = onColor
               immediateView.backgroundColor = onColor
        case  ...0: //1 .unknown:
                unknownView.backgroundColor = onColor
                farView.backgroundColor = offColor
                nearView.backgroundColor = offColor
                immediateView.backgroundColor = offColor
        default:
            break
        }
    }
}
