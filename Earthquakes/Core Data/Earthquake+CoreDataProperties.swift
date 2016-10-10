//
//  Earthquake+CoreDataProperties.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 12/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import CoreData


extension Earthquake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Earthquake> {
        return NSFetchRequest<Earthquake>(entityName: "Earthquake");
    }

    @NSManaged public var name: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var magnitude: Double
    @NSManaged public var depth: Double
    @NSManaged public var url: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var identificator: String?

}
