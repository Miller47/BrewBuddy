//
//  ReviewViewController.swift
//
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit
import Parse

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var ratingStars: HCSStarRatingView!
    
    var id: String?
    var point: PFGeoPoint?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint, error) -> Void in
            if error == nil {
                self.point = geoPoint
                if let pointTemp = self.point {
                    println(pointTemp)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let brewId = self.id {
            println("BrewId: \(brewId)")
        }
        
        
        
    }
    
    @IBAction func postReview() {
        
        SVProgressHUD.showWithStatus("Posting Review")
        showNetworkActivityIndicator(true)
        
        
        if let brewId = id {
            println("BrewId: \(brewId)")
            
            var query = PFQuery(className: "Brewery")
            query.whereKey("breweryId", equalTo: brewId)
            query.findObjectsInBackgroundWithBlock({ (breweries: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    var rating = PFObject(className: "Ratings")
                    rating["rating"] = self.ratingStars.value
                    rating["userName"] = PFUser.currentUser()?.username
                    if let loc = self.point {
                        rating["location"] = loc
                    }
                    
                    
                    if let breweries = breweries as? [PFObject] {
                        if breweries.count > 0 {
                            var brewery = breweries.first
                            
                            brewery?.addObject(rating, forKey: "rating")
                            
                            brewery?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if success {
                                    
                                    SVProgressHUD.dismiss()
                                    self.showNetworkActivityIndicator(false)
                                    
                                    //dimiss review
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    
                                    NSNotificationCenter.defaultCenter().postNotificationName("refreshReviewData", object: nil)
                                    
                                    
                                } else {
                                    SVProgressHUD.dismiss()
                                    self.showNetworkActivityIndicator(false)
                                    if let error = error {
                                        let errorString = error.userInfo?["error"] as? NSString
                                        let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion:nil)
                                    }
                                }
                                
                                
                            })
                            
                        } else {
                            var brewery = PFObject(className: "Brewery")
                            brewery["breweryId"] = brewId
                            if let loc  = self.point {
                                brewery["location"] = loc
                            }
                            brewery.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if success {
                                    
                                    brewery.addObject(rating, forKey: "rating")
                                    brewery.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                        if success {
                                            
                                            SVProgressHUD.dismiss()
                                            self.showNetworkActivityIndicator(false)
                                            
                                            //dimiss review
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            
                                            NSNotificationCenter.defaultCenter().postNotificationName("refreshReviewData", object: nil)
                                            
                                            
                                        } else {
                                            SVProgressHUD.dismiss()
                                            self.showNetworkActivityIndicator(false)
                                            if let error = error {
                                                let errorString = error.userInfo?["error"] as? NSString
                                                let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                                                alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                                self.presentViewController(alert, animated: true, completion:nil)
                                            }
                                        }
                                        
                                        
                                    })
                                    
                                    
                                } else {
                                    SVProgressHUD.dismiss()
                                    self.showNetworkActivityIndicator(false)
                                    if let error = error {
                                        let errorString = error.userInfo?["error"] as? NSString
                                        let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion:nil)
                                    }
                                }
                                
                                
                            })
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
            })
            
            
            
        }
    }
}
