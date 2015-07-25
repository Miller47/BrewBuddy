//
//  AddBreweryViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/15/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit

class AddBreweryViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var breweryDescription: UITextField!
    
    
    
    @IBAction func save() {
        
        //intail post test
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.brewerydb.com/v2/breweries?key=46fdb18ac2e65c0422cdd01a915d63cb")!)
        request.HTTPMethod = "POST"
        
        if name.text.isEmpty == false && website.text.isEmpty == false && breweryDescription.text.isEmpty == false {
            
            if self.name.isFirstResponder() || self.website.isFirstResponder() || self.breweryDescription.isFirstResponder() {
                self.view.endEditing(true)
            }
            
            let postString = "name=\(name.text)&website=\(website.text)&description=\(breweryDescription.text)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                //prevents crash if textfiled is still selected
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if error != nil {
                        let errorString = error.userInfo?["error"] as? NSString
                        let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion:nil)
                        
                    } else {
                        if let data = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                            
                            println("Response: \(data)")
                            let alert = UIAlertController(title: "Success", message: "The data will be reviewed in order to ensure quality", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion:nil)
                        }
                        
                        self.name.text = nil
                        self.website.text = nil
                        self.breweryDescription.text = nil
                        
                        
                    }
                    
                })
                
            })
            
            task.resume()
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fileds", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion:nil)
            
        }
    }
    
}
