//
//  CoreDataManager.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 25/11/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

   class func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
