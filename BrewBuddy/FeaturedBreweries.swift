//
//  FeaturedBreweries.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/15/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation

struct FeaturedBreweries {
    
    let name: String?
    let breweryId: String?
    let largeIconURL: String?
    let streetAddress: String?
    let locality: String?
    let region: String?
    let phone: String?
    let website: String?
    let hours: String?
    let established: String?
    let isClosed: String?
    let openToPublic: String?
    let locationTypeDisplay: String?
    
    init(brewDictionary: [String: AnyObject], brewArray: [[String: AnyObject]]) {
        // Gets the correct index from array
        var location = brewArray[0]
        for i in 0..<brewArray.count {
            println("i: \(i)")
            location = brewArray[i]
        }
        
        name = brewDictionary["brewery"]?["name"] as? String
        breweryId = brewDictionary["breweryId"] as? String
        largeIconURL = brewDictionary["brewery"]?["images"]??["large"] as? String
        hours = location["hoursOfOperation"] as? String
        streetAddress = location["streetAddress"] as? String
        locality = location["locality"] as? String
        region = location["region"] as? String
        phone = location["phone"] as? String
        website = brewDictionary["brewery"]?["website"] as? String
        established = brewDictionary["brewery"]?["established"] as? String
        isClosed = location["isClosed"] as? String
        openToPublic = location["openToPublic"] as? String
        locationTypeDisplay = location["locationTypeDisplay"] as? String
        
        
    }
    
}
