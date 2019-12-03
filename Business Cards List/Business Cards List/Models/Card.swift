//
//  Card.swift
//  Business Cards List
//
//  Created by Ilya on 30.11.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

class Card {
    
    static var shared = [Card]()
    
    var id: String
    var name: String?
    var description: String?
    var iconName: String?
    
    init(id: String, data: JSON) {
        self.id     = id
        self.name  = data["name"] as! String?
        self.description   = data["description"] as! String?
        self.iconName   = data["iconName"] as! String?
        
        // MARK: - Initialization
    
    }
}
