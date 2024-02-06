//  
//  BeaconCell.swift
//  app-uniurbino
//
//  Created by AppLoad on 03/07/23.
//

import UIKit

class BeaconCell: UITableViewCell{
    
    @IBOutlet var pointLbl: UILabel!
    @IBOutlet var logLabel: UILabel!
    
    //PROXIMITY
    @IBOutlet weak var unknownView: UIView!
    @IBOutlet weak var farView: UIView!
    @IBOutlet weak var nearView: UIView!
    @IBOutlet weak var immediateView: UIView!
    
    @IBOutlet weak var genericView: GenericView!
    @IBOutlet weak var signalStack: UIStackView!
    
    let onColor = UIColor.black
    let offColor = UIColor.systemGray5

    //MARK: - Class Properties
    
    class var nibName: UINib  {
        get{
            return UINib(nibName: String(describing: BeaconCell.self), bundle: nil)
        }
    }
    
    class var identifier: String  {
        get{
            return String(describing: BeaconCell.self)
        }
    }

    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
//    MARK: - private methods
   
    
    func configureView(beaconDistance: Double?){
        guard let beaconDistance else {
            signalStack.isHidden = true
            return
        }
        signalStack.isHidden = false
        switch beaconDistance {
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
