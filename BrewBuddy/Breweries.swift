//
//  Breweries.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/8/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation
import UIKit

struct Breweries {
    let name: String?
    let breweryId: String?
    let distance: Double?
    var iconURL: String?
    
    init(brewDictionary: [String: AnyObject]) {
        
        name = brewDictionary["brewery"]?["name"] as? String
        breweryId = brewDictionary["breweryId"] as? String
        distance = brewDictionary["distance"] as? Double
        iconURL = brewDictionary["brewery"]?["images"]??.objectForKey("icon") as? String
        
        
    }
}
