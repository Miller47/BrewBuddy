//
//  DetailViewController.swift
//
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit
import Parse
import Haneke


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var breweryImage: UIImageView!
    
    var nameText: String?
    var phoneNum: String?
    var loc: String?
    var websiteURL: String?
    var imageURL: String?
    var breweryId: String?
    var reviews: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        name.text = nameText
        location.text = loc
        if imageURL != nil {
            let URL = NSURL(string: imageURL!)
            breweryImage.hnk_setImageFromURL(URL!)
        }
        if phoneNum == nil {
            phone.setTitle("No Phone Listed", forState: UIControlState.Normal)
            
        }
        if websiteURL == nil {
            website.setTitle("No Website Listed", forState: UIControlState.Normal)
        }
        
        //register as obsever
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "retriveReviews", name: "refreshReviewData", object: nil)
        
        retriveReviews()
        
    }
    
    
    @IBAction func call(sender: AnyObject) {
        //Calls number
        if let num = phoneNum, let url = NSURL(string: "tel://\(num)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func visitWebsite() {
        //open website will add native in app support
        if let site = websiteURL, let url = NSURL(string: site) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func getDirections() {
        if let loc = loc {
            let query = loc.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let activityController = UIAlertController(title: "Open In", message: "Please choose either Apple maps or Google maps", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                
            })
            activityController.addAction(cancelAction)
            
            let appleMaps = UIAlertAction(title: "Apple Maps", style: .Default, handler: { (action) -> Void in
                
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?q=\(query)")!)
            })
            activityController.addAction(appleMaps)
            
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                
                let googleMaps = UIAlertAction(title: "Google Maps", style: .Default, handler: { (action) -> Void in
                    
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?q=\(query)")!)
                })
                activityController.addAction(googleMaps)
            }
            
            self.presentViewController(activityController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func postReview(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier("showReview", sender: nil)
        
    }
    
    func retriveReviews() {
        
        SVProgressHUD.showWithStatus("Retriving Data")
        showNetworkActivityIndicator(true)
        
        var query = PFQuery(className: "Reviews")
        if let brewId = breweryId {
            query.whereKey("breweryId", equalTo: brewId)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let data = results {
                        self.reviews = data
                        self.reviewTableView.reloadData()
                        SVProgressHUD.dismiss()
                        self.showNetworkActivityIndicator(false)
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
                    
                }
            })
        }
        
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reviews.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! ReviewTableViewCell
        
        //Configure the cell...
        let reviewInfo: PFObject = reviews[indexPath.row] as! PFObject
        
        if let userName = reviewInfo.objectForKey("userName") as? String, let ratingVal = reviewInfo.objectForKey("rating") as? CGFloat {
            
            cell.userName.text = userName
            cell.rating.value = ratingVal
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.918,  green:0.894,  blue:0.886, alpha:0.85)
        } else {
            cell.backgroundColor = UIColor(red:0.929,  green:0.922,  blue:0.918, alpha:0.85)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReview" {
            
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
