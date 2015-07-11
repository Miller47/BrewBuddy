//
//  SettingsTableViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/10/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        var currentUserName: String?
        
        if currentUser != nil {
            if let currentUserName = currentUser?.username {
                self.userLabel.text = "Logged in as: \(currentUserName)"
            }
            
        }
        
    }
    
    
    @IBAction func logOut() {
        
        PFUser.logOutInBackground()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Show Login
        
        let VC = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.presentViewController(VC, animated: true, completion: nil)
    
        
        
    }
    
    
}