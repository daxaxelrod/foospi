//
//  GameTableViewCell.swift
//  FoosPiV2
//
//  Created by David Axelrod on 7/20/16.
//  Copyright © 2016 David Axelrod. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    //propeties
    
    
    @IBOutlet weak var gameID: UITextField!
    
    @IBOutlet weak var winner: UITextField!
    
    @IBOutlet weak var duration: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
