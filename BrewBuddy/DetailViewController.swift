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


class DetailViewController: UITableViewController {
    
    @IBOutlet weak var addFav: UIBarButtonItem!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var breweryImage: UIImageView!
    @IBOutlet weak var openToPublic: UILabel!
    @IBOutlet weak var closed: UILabel!
    @IBOutlet weak var established: UILabel!
    @IBOutlet weak var type: UILabel!
    
    
    private let APIKey = "46fdb18ac2e65c0422cdd01a915d63cb"
    var nameText: String?
    var phoneNum: String?
    var loc: String?
    var websiteURL: String?
    var imageURL: String?
    var breweryId: String?
    var open: String?
    var closedValue: String?
    var establishedDate: String?
    var typeOfBrewery: String?
    var isFav: Bool?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Ensures tableview starts below navbar
        tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        setBackBtnText()
        
        setUpView()
        
        setFavIcon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set tablewview to not hidden
        tableView.hidden = false
    }
    
    func setFavIcon() {
        if let id =  breweryId {
            var query = PFQuery(className: "Favorites")
            query.whereKey("breweryId", equalTo: id)
            query.findObjectsInBackgroundWithBlock { (favs, error) -> Void in
                
                if error == nil {
                    if let fav = favs as? [PFObject] {
                        for item in fav {
                            println(item.objectForKey("isFav")!)
                            self.isFav = item.objectForKey("isFav") as? Bool
                        }
                        
                        if let fav = self.isFav {
                            self.addFav.image = UIImage(named: "favSelected")!
                        }
                    }
                }
            }
        }
    }
    
    func setUpView() {
        
        if nameText != nil {
            name.text = nameText
        }
        
        if loc != nil {
            location.text = loc
        }
        if imageURL != nil {
            if let URL = NSURL(string: imageURL!) {
                breweryImage.hnk_setImageFromURL(URL)
            }
        }
        if phoneNum == nil {
            phone.text = "No Phone Listed"
            
        } else {
            phone.text = phoneNum
        }
        if websiteURL == nil {
            website.text = "No Website Listed"
        } else {
            website.text = websiteURL
        }
        
        if open != nil {
            if open == "Y" {
                openToPublic.text = "Open to public: Yes"
            } else if open == "N" {
                
                openToPublic.text = "Open to public: No"
            }
        }
        if closedValue != nil {
            if closedValue == "Y" {
                closed.text = "In Buisiness: No"
            } else {
                closed.text = "In Buisiness: Yes"
            }
        }
        if establishedDate != nil {
            established.text = "Established: \(establishedDate!)"
        } else {
            established.text = "Established: N/A"
        }
        if typeOfBrewery != nil {
            type.text = "Type: \(typeOfBrewery!)"
        }
    }
    
    
    func call() {
        //Calls number
        if let num = phoneNum, let url = NSURL(string: "tel://\(num)") {
            let alert = UIAlertController(title: "Call?", message: "Are you sure you want to call?", preferredStyle: .Alert)
            let noAction = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
            alert.addAction(noAction)
            let yesAction = UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
                UIApplication.sharedApplication().openURL(url)
            })
            alert.addAction(yesAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func visitWebsite() {
        //open website will add native in app support
        if let site = websiteURL, let url = NSURL(string: site) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func getDirections() {
        if let loc = loc {
            let query = loc.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let activityController = UIAlertController(title: "Open In", message: "Please choose either Apple maps or Google maps", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
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
    
    
    @IBAction func addToFavorites(sender: AnyObject) {
        println("Fav")
        if let fav = isFav {
            SVProgressHUD.showWithStatus("Removing favorite")
            showNetworkActivityIndicator(true)
            
            if let id =  breweryId {
                var query = PFQuery(className: "Favorites")
                query.whereKey("breweryId", equalTo: id)
                query.findObjectsInBackgroundWithBlock({ (favs, error) -> Void in
                    if error == nil {
                        if let favorite = favs as? [PFObject] {
                            for item in favorite {
                                item.deleteInBackgroundWithBlock({ (done, error) -> Void in
                                    SVProgressHUD.dismiss()
                                    self.showNetworkActivityIndicator(false)
                                    self.addFav.image = UIImage(named: "fav")
                                })
                            }
                        }
                        
                        
                    }
                })
            }
            
        } else {
            SVProgressHUD.showWithStatus("Saving as Favorite")
            showNetworkActivityIndicator(true)
            
            if let id = breweryId {
                
                var fav = PFObject(className: "Favorites")
                fav["breweryId"] = id
                
                if  let name = nameText {
                    fav["breweryName"] = name
                }
                
                
                if let icon = imageURL {
                    fav["icon"] = icon
                }
                
                if let location = loc {
                    fav["loc"] = location
                }
                fav["isFav"] = true
                
                if let currentUser = PFUser.currentUser() {
                    fav.ACL = PFACL(user: currentUser)
                    println("Current User: \(currentUser)")
                }
                fav.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        
                        SVProgressHUD.dismiss()
                        self.showNetworkActivityIndicator(false)
                        self.addFav.image = UIImage(named: "favSelected")
                        
                        
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
    
    
    func getBreweryById(id: String) {
        
        SVProgressHUD.showWithStatus("Retrieving brewery")
        showNetworkActivityIndicator(true)
        let byId = BreweryByIdService(APIKey: APIKey)
        byId.getById(id) {
            (let brew) in
            if let info = brew, let data = info.brewery {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageURL = data.largeIconURL
                    self.nameText = data.name
                    self.loc = data.streetAddress! + " " + data.locality! + ", " + data.region!
                    self.websiteURL = data.website
                    self.phoneNum = data.phone
                    self.breweryId = data.breweryId
                    self.open = data.openToPublic
                    self.closedValue =  data.isClosed
                    self.establishedDate = data.established
                    self.typeOfBrewery = data.locationTypeDisplay
                    
                    self.setUpView()
                    self.setFavIcon()
                    
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                })
            }
        }
        
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                getDirections()
            case 1:
                call()
            case 2:
                visitWebsite()
            default:
                println("Noting")
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserReviews" {
            
            if let VC: ReviewsTableViewController = segue.destinationViewController as? ReviewsTableViewController {
                
                
                //pass data
                if let brewId = breweryId {
                    VC.breweryId = brewId
                }
            }
            
        }
    }
    
    
}
