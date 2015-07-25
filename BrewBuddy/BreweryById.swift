//
//  BreweryById.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/18/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation

struct BrweryById {
    
    let name: String?
    let breweryId: String?
    let largeIconURL: String?
    let streetAddress: String?
    let locality: String?
    let region: String?
    let phone: String?
    let website: String?
    let openToPublic: String?
    let isClosed: String?
    let locationTypeDisplay: String?
    let established: String?
    
    init(brewDictionary: [String: AnyObject], brewArray: [[String: AnyObject]]) {
        // Gets the correct index from array
        var location = brewArray[0]
        for i in 0..<brewArray.count {
            println("i: \(i)")
            location = brewArray[i]
        }
        
        name = brewDictionary["name"] as? String
        breweryId = brewDictionary["id"] as? String
        largeIconURL = brewDictionary["images"]?["large"] as? String
        streetAddress = location["streetAddress"] as? String
        locality = location["locality"] as? String
        region = location["region"] as? String
        phone = location["phone"] as? String
        website = brewDictionary["website"] as? String
        openToPublic = location["openToPublic"] as? String
        isClosed = location["isClosed"] as? String
        locationTypeDisplay = location["locationTypeDisplay"] as? String
        established = brewDictionary["established"] as? String
        
        
    }
    
}
