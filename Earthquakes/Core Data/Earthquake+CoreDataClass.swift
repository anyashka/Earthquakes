//
//  Earthquake+CoreDataClass.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 11/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Earthquake: NSManagedObject {

    class func createEarthquake(from earthquake: Quake, inContext context: NSManagedObjectContext) {
        guard let newEarthquake = NSEntityDescription.insertNewObject(forEntityName: "Earthquake", into: context) as? Earthquake else { return }
        
        newEarthquake.name = earthquake.name
        newEarthquake.time = earthquake.date as NSDate?
        newEarthquake.depth = earthquake.depth
        newEarthquake.latitude = earthquake.latitude
        newEarthquake.longitude = earthquake.longitude
        newEarthquake.magnitude = earthquake.magnitude
        newEarthquake.url = earthquake.url
        newEarthquake.identificator = earthquake.indentificator
        
        CoreDataManager.save(context: context)
    }
    
    func mapToQuake() -> Quake? {
        guard let name = self.name, let date = self.time as? Date, let url = self.url, let identificator = self.identificator else { return nil }
        return Quake(name: name, magnitude: self.magnitude, date: date, url: url, latitude: self.latitude, longitude: self.longitude, depth: self.depth, indentificator: identificator)
    }
    
    class func isFavourite (quake: Quake, inContext context: NSManagedObjectContext) -> Bool {
        let identificator = quake.indentificator
        let fetchRequest: NSFetchRequest<Earthquake> = Earthquake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identificator = %@", argumentArray: [identificator])

        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 1 {
                return true
            } else {
                return false
            }
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            return false
        }
    }
    
    class func removeFromFavourites (quake: Quake, inContext context: NSManagedObjectContext) {
        let identificator = quake.indentificator
        let fetchRequest: NSFetchRequest<Earthquake> = Earthquake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identificator = %@", argumentArray: [identificator])
        
        do {
            let earthquakeObject = try context.fetch(fetchRequest)
            guard earthquakeObject.count == 1, let eartquake = earthquakeObject.first else { return }
            context.delete(eartquake)
            CoreDataManager.save(context: context)
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
}
