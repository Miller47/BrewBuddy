//
//  FavoritesViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/18/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit
import Parse

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites: [AnyObject] = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        retriveFavorites()
    }
    
    func retriveFavorites() {
        SVProgressHUD.showWithStatus("Retriving Favorites")
        showNetworkActivityIndicator(true)
        
        var query = PFQuery(className: "Favorites")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let data = results {
                    self.favorites = data
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
        }
        
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return favorites.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BeerTableViewCell
        
        //Configure the cell...
        let favInfo: PFObject = favorites[indexPath.row] as! PFObject
        
        if let breweryName = favInfo.objectForKey("breweryName") as? String {
            
            cell.breweryName.text = breweryName
        }
        
        if let location = favInfo.objectForKey("loc") as? String {
            
            cell.distance.text = location
        }
        if let icon = favInfo.objectForKey("icon") as? String {
            
            if let iconURL = NSURL(string: icon) {
                cell.breweryImage.pin_setImageFromURL(iconURL, placeholderImage: UIImage(named: "brewbuddy"))
                
            }
            
            
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let user = PFUser.currentUser()
            let selectedObject: PFObject = favorites[indexPath.row] as! PFObject
            selectedObject.deleteInBackground()
            retriveFavorites()
            favorites.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowDetail") {
            
            
            if let VC: DetailViewController = segue.destinationViewController as? DetailViewController{
                
                
                
                if let row = self.tableView.indexPathForSelectedRow()?.row {
                    let favInfo: PFObject = favorites[row] as! PFObject
                    
                    if let id = favInfo.objectForKey("breweryId") as? String {
                        VC.getBreweryById(id)
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
}
