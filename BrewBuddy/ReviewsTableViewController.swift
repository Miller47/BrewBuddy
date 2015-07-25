//
//  ReviewsTableViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/23/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit
import Parse

class ReviewsTableViewController: UITableViewController {
    
    var breweryId: String?
    var reviews: [AnyObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //register as obsever
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "retriveReviews", name: "refreshReviewData", object: nil)
        
        retriveReviews()
    }
    
    func retriveReviews() {
        
        SVProgressHUD.showWithStatus("Retriving Data")
        showNetworkActivityIndicator(true)
        
        var query = PFQuery(className: "Reviews")
        if let brewId = breweryId {
            println(brewId)
            query.whereKey("breweryId", equalTo: brewId)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let data = results {
                        self.reviews = data
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        self.showNetworkActivityIndicator(false)
                    }
                    
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ReviewTableViewCell
        
        //Configure the cell...
        if let reviewInfo: PFObject = reviews[indexPath.row] as? PFObject {
            
            if let userName = reviewInfo.objectForKey("userName") as? String, let ratingVal = reviewInfo.objectForKey("rating") as? CGFloat {
                
                cell.userName.text = userName
                cell.rating.value = ratingVal
            }
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.918,  green:0.894,  blue:0.886, alpha:0.85)
        } else {
            cell.backgroundColor = UIColor(red:0.929,  green:0.922,  blue:0.918, alpha:0.85)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showReviewInput" {
            
            if let VC: ReviewViewController = segue.destinationViewController as? ReviewViewController {
                
                let presentsationSegue = segue as! MZFormSheetPresentationControllerSegue
                presentsationSegue.formSheetPresentationController.shouldDismissOnBackgroundViewTap = true
                
                presentsationSegue.formSheetPresentationController.shouldApplyBackgroundBlurEffect = true
                presentsationSegue.formSheetPresentationController.shouldCenterVertically = true
                presentsationSegue.formSheetPresentationController.contentViewSize = CGSizeMake(250, 250)
                
                //pass data
                if let brewId = breweryId {
                    VC.id = brewId
                }
            }
            
        }
        

    }
    
    
    
    
}
