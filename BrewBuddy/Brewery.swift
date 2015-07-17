//
//  Brewery.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/9/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation

struct Brewery {
    
    var breweries: [Breweries] = []
    var featured: FeaturedBreweries?
    
    init(breweyDictionary: [String: AnyObject]?) {
        if let breweryArray = breweyDictionary?["data"] as? [[String: AnyObject]] {
            
            for brewery in breweryArray {
                let breweryInfo = Breweries(brewDictionary: brewery)
                breweries.append(breweryInfo)
            }
            
            
        }
        
        if let dataDict = breweyDictionary?["data"] as? [String: AnyObject], let breweryDict = dataDict["brewery"] as? [String: AnyObject], let locationArray = breweryDict["locations"] as? [[String: AnyObject]] {
            
            featured = FeaturedBreweries(brewDictionary: dataDict, brewArray: locationArray)
            
            
        }
    }
}

