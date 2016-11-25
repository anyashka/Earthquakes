//
//  Date.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 11/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit

extension Date {
    func asString() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: self)
        return dateString
    }
    
    init(longIntTimeIntervalSince1970: Double) {
        self.init(timeIntervalSince1970: longIntTimeIntervalSince1970/1000)
    }
    
    func dateAsString() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        let dateString = dayTimePeriodFormatter.string(from: self)
        return dateString
    }
    
    func timeAsString() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: self)
        return dateString
    }
    
    func asString14DaysFromNow() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd"
        let minus14Days = TimeInterval(-14*24*60*60)
        let dateString = dayTimePeriodFormatter.string(from: self.addingTimeInterval(minus14Days))
        return dateString
    }
}

