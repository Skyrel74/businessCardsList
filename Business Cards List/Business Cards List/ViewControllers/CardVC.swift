//
//  Card.swift
//  Business Cards List
//
//  Created by Ilya on 30.11.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit

class CardVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
    func setup(with card: Card) {
        nameLabel.text = card.name
        
    }
}
