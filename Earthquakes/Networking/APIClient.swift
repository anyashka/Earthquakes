//
//  APIClient.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 11/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class APIClient {

    class func getListOfEarthquakes(completionBlock: @escaping ( _ info: Any) -> Void) {
        Alamofire.request("http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(Date().asString14DaysFromNow())")
            .validate(statusCode: 200..<201)
            .responseJSON { response -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching earthquakes: \(response.result.error)")
                    return
                }
                let json = response.result.value
                completionBlock(json)
            }
    }
    
}
