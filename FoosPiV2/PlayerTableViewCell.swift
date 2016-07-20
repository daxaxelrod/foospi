//
//  PlayerTableViewCell.swift
//  FoosPiV2
//
//  Created by David Axelrod on 7/19/16.
//  Copyright © 2016 David Axelrod. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var winsAndLosses: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
