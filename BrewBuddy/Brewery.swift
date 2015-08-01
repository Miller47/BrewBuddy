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
    var brewery: BrweryById?
    
    init(breweyDictionary: [String: AnyObject]?) {
        if let breweryArray = breweyDictionary?["data"] as? [[String: AnyObject]] {
            
            for brewery in breweryArray {
                let breweryInfo = Breweries(brewDictionary: brewery)
                breweries.append(breweryInfo)
            }
            
            
        }
        
        
        if let breweryByIdDict = breweyDictionary?["data"] as? [String: AnyObject], let locArray = breweryByIdDict["locations"] as? [[String: AnyObject]] {
            
            brewery = BrweryById(brewDictionary: breweryByIdDict, brewArray: locArray)
        }
    }
}

