//
//  EarthquakeTableViewCell.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 10/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit

class EarthquakeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    class var cellIdentifier: String {
        return "EarthquakeTableViewCell"
    }
    
    func configure(withName name: String, date: Date, magnitude: Double) {
        nameLabel.text = name
        timeLabel.text = date.asString()
        magnitudeLabel.text = String(magnitude)
    }
}
