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
             var review = PFObject(className: "Reviews")
            review["breweryId"] = brewId
            review["userName"] = PFUser.currentUser()?.username
            review["rating"] = ratingStars.value
            review.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
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
        }
    }
}
