//
//  FeaturedBreweriesService.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/15/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation

struct FeaturedBreweriesService {
    
    let breweryDbAPIKey: String
    let breweryDbBaseUrl: NSURL?
    
    init(APIKey: String) {
        self.breweryDbAPIKey = APIKey
        breweryDbBaseUrl = NSURL(string: "https://api.brewerydb.com/v2/")
    }
    
    func getFeatured(completion: (Brewery? -> Void)) {
        
        if let breweryURL = NSURL(string: "featured?key=\(breweryDbAPIKey)&format=json", relativeToURL: breweryDbBaseUrl) {
            println(breweryURL.absoluteString)
            
            let networkOperation = NetworkOperation(url: breweryURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSON) in
                let breweries = Brewery(breweyDictionary: JSON)
                completion(breweries)
                println(breweries)
            }
        } else {
            println("Coukd not constuct a vaild URL")
        }
    }
    
    
}