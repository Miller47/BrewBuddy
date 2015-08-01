//
//  AddBreweryViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/15/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit

class AddBreweryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var breweryDescription: UITextField!
    @IBOutlet weak var established: UITextField!
    @IBOutlet weak var breweryImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var base64Str: String?
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        name.text = nil
        website.text = nil
        breweryDescription.text = nil
        established.text = nil
        breweryImage.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    @IBAction func addImage() {
        
        
        
        
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = false
        
        
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        breweryImage.contentMode = .ScaleAspectFit
        breweryImage.image = image
        //possible memroy warining fix
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let imageData = UIImagePNGRepresentation(image)
            self.base64Str = imageData.base64EncodedStringWithOptions(.allZeros)
        })
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save() {
        
        //intail post test
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.brewerydb.com/v2/breweries?key=46fdb18ac2e65c0422cdd01a915d63cb")!)
        request.HTTPMethod = "POST"
        
        if name.text.isEmpty == false && website.text.isEmpty == false && breweryDescription.text.isEmpty == false  && established.text.isEmpty == false {
            
            if self.name.isFirstResponder() || self.website.isFirstResponder() || self.breweryDescription.isFirstResponder() || self.established.isFirstResponder() {
                self.view.endEditing(true)
            }
            var postString: String?
            
            if breweryImage.image != nil {
                
                
                if let baseStr = base64Str {
                    
                    let str = (baseStr as NSString).stringByReplacingOccurrencesOfString("+", withString: "%2B")
                    //                    println(str)
                    
                    postString = "name=\(name.text)&image=\(str)&website=\(website.text)&description=\(breweryDescription.text)&established=\(established.text)"
                    
                }
            } else {
                
                postString = "name=\(name.text)&website=\(website.text)&description=\(breweryDescription.text)&established=\(established.text)"
            }
            if let post = postString {
                SVProgressHUD.show()
                showNetworkActivityIndicator(true)
                request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding)
                
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
                            if let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                                println("Response: \(dataStr)")
                                
                                var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                                if let jsonResponse: AnyObject = json {
                                    var outPut = jsonResponse["status"] as! String
                                    
                                    println("Response: \(outPut)")
                                    
                                    if outPut == "success" {
                                        let alert = UIAlertController(title: "Success", message: "The data will be reviewed in order to ensure quality", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion:nil)
                                    } else {
                                        let alert = UIAlertController(title: "Failiure", message: "something went wrong.", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion:nil)
                                    }
                                }
                            }
                            
                            SVProgressHUD.dismiss()
                            self.showNetworkActivityIndicator(false)
                            self.name.text = nil
                            self.website.text = nil
                            self.breweryDescription.text = nil
                            self.established.text = nil
                            self.breweryImage.image = nil
                            
                            
                        }
                        
                    })
                    
                })
                
                task.resume()
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fileds", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion:nil)
            
        }
        
    }
    
}
