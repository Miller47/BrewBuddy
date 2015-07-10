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
    let largeIconURL: String?
    let streetAddress: String?
    let locality: String?
    let region: String?
    let phone: String?
    let website: String?
    
    init(brewDictionary: [String: AnyObject]) {
        
        name = brewDictionary["brewery"]?["name"] as? String
        breweryId = brewDictionary["breweryId"] as? String
        distance = brewDictionary["distance"] as? Double
        largeIconURL = brewDictionary["brewery"]?["images"]??.objectForKey("large") as? String
        streetAddress = brewDictionary["streetAddress"] as? String
        locality = brewDictionary["locality"] as? String
        region = brewDictionary["region"] as? String
        phone = brewDictionary["phone"] as? String
        website = brewDictionary["website"] as? String
        
        
    }
}
