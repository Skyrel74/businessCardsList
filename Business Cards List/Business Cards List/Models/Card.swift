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
    var name: String
    var description: String?
    var iconName: String?
    
    // MARK: - Initialization
    
    init(name: String, description: String?, iconName: String?) {
        self.id = ""
        self.name = "Napoleon IT"
    }
    
    
}
