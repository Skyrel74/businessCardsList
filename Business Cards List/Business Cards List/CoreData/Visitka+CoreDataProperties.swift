//
//  Visitka+CoreDataProperties.swift
//  Business Cards List
//
//  Created by MacBook Pro on 09.12.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//
//

import Foundation
import CoreData


extension Visitka {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visitka> {
        return NSFetchRequest<Visitka>(entityName: "Visitka")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var idCard: String?
    @NSManaged public var name: String?

}
