//
//  NetworkOperation.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/8/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation


class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        let request = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //Check rsponse
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                case 200:
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                    
                default:
                    println("GET response not sucessful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                println("NOt valid error")
            }
            //Create JSONObject with data
        }
        
        dataTask.resume()
        
    }
}