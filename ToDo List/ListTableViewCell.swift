//
//  ListTableViewCell.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/4/22.
//

import UIKit

// Table View Cell can send a message to any view controller to agrees to be its delegate
protocol ListTableViewCellDelegate: AnyObject {
    func checkBoxToggled(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    weak var delegate: ListTableViewCellDelegate?
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggled(sender: self )
    }
    
}
