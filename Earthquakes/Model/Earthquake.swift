//
//  Earthquake.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 11/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit
import SwiftyJSON

class Quake: NSObject {
    
    var name: String
    var magnitude: Double
    var date: Date
    var url: String
    var latitude: Double
    var longitude: Double
    var depth: Double
    var indentificator: String
    
    init(name: String, magnitude: Double, date: Date, url: String, latitude: Double, longitude: Double, depth: Double, indentificator: String) {
        self.name = name
        self.magnitude = magnitude
        self.date = date
        self.url = url
        self.latitude = latitude
        self.longitude = longitude
        self.depth = depth
        self.indentificator = indentificator
    }
    
    class func parse(earthquakeJSON: JSON) -> Quake? {
        
        let earthquakeProperties = earthquakeJSON["properties"].dictionaryValue
        
        guard let name = earthquakeProperties["place"]?.stringValue,
            let magnitude = earthquakeProperties["mag"]?.doubleValue,
            let time = earthquakeProperties["time"]?.doubleValue,
            let url = earthquakeProperties["url"]?.stringValue else {
                return nil
        }
        
        guard let earthquakeCoordinates = earthquakeJSON["geometry"].dictionaryValue["coordinates"]?.arrayValue else {
            return nil
        }
        
        let longitude = earthquakeCoordinates[0].doubleValue
        let latitude = earthquakeCoordinates[1].doubleValue
        let depth = earthquakeCoordinates[2].doubleValue
        
        let date = Date(longIntTimeIntervalSince1970: time)
        
        let identificator = earthquakeJSON["id"].stringValue
        
        let earthquake = Quake(name: name, magnitude: magnitude, date: date, url: url, latitude: latitude, longitude: longitude, depth: depth, indentificator: identificator)
        
        return earthquake
    }
    
}
