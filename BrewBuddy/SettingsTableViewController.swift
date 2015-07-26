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
    
    
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = PFUser.currentUser()
        var currentUserName: String?
        
        if currentUser != nil {
            if let currentUserName = currentUser?.username {
                self.navigationItem.title = "Logged in as: \(currentUserName)"
            }
            
        }
        
    }
    
    
    @IBAction func logOut() {
        
        logOutCurrentuser()
        
    }
    
    func logOutCurrentuser() {
        PFUser.logOutInBackground()
        let user = PFUser.currentUser()
        println("user: session \(user?.sessionToken)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Show Login
        
        let VC = storyBoard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
        self.presentViewController(VC, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let changeEmail = UIAlertController(title: "Change e-mail", message: "Enter your desired email", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                
            })
            changeEmail.addAction(cancelAction)
            let inputAction =  UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
                if let inputField = changeEmail.textFields?.first as? UITextField {
                    if !(inputField.text.isEmpty) {
                        SVProgressHUD.showWithStatus("Changing e-mail")
                        self.showNetworkActivityIndicator(true)
                        self.currentUser?.email = inputField.text
                        self.currentUser?.saveInBackgroundWithBlock({ (pass: Bool, error: NSError?) -> Void in
                            if error == nil {
                                SVProgressHUD.dismiss()
                                self.showNetworkActivityIndicator(false)
                                let alert = UIAlertController(title: "Please verify your email", message: "An email has been sent to the provided address in order to verify your new email.", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion:nil)
                                
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
                        let alert = UIAlertController(title: "Error", message: "Make sure you provide an email", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            })
            changeEmail.addAction(inputAction)
            changeEmail.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.textColor = UIColor(red: 0.325, green: 0.792, blue: 0.714, alpha: 1)
            }
            self.presentViewController(changeEmail, animated: true, completion: nil)
            
        case 1:
            let changeUsername = UIAlertController(title: "Change Username", message: "Enter your desired username", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                
            })
            changeUsername.addAction(cancelAction)
            let inputAction =  UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
                if let inputField = changeUsername.textFields?.first as? UITextField {
                    if !(inputField.text.isEmpty) {
                        SVProgressHUD.showWithStatus("Changing username")
                        self.showNetworkActivityIndicator(true)
                        self.currentUser?.username = inputField.text
                        self.currentUser?.saveInBackgroundWithBlock({ (pass: Bool, error: NSError?) -> Void in
                            if error == nil {
                                SVProgressHUD.dismiss()
                                self.showNetworkActivityIndicator(false)
                                if let currentUserName = self.currentUser?.username {
                                    self.navigationItem.title = "Logged in as: \(currentUserName)"
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
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Make sure you provide an username", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            })
            changeUsername.addAction(inputAction)
            changeUsername.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.textColor = UIColor(red: 0.325, green: 0.792, blue: 0.714, alpha: 1)
            }
            self.presentViewController(changeUsername, animated: true, completion: nil)
            
        case 2:
            let changePassword = UIAlertController(title: "Change password", message: "Enter your desired password. Please note changing your password will require you to login once more.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                
            })
            changePassword.addAction(cancelAction)
            let inputAction =  UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
                if let inputField = changePassword.textFields?.first as? UITextField {
                    if !(inputField.text.isEmpty) {
                        SVProgressHUD.showWithStatus("Changing password")
                        self.showNetworkActivityIndicator(true)
                        self.currentUser?.password = inputField.text
                        self.currentUser?.saveInBackgroundWithBlock({ (pass: Bool, error: NSError?) -> Void in
                            if error == nil {
                                SVProgressHUD.dismiss()
                                self.showNetworkActivityIndicator(false)
                                self.logOutCurrentuser()
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
                        let alert = UIAlertController(title: "Error", message: "Make sure you provide an password", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            })
            changePassword.addAction(inputAction)
            changePassword.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.textColor = UIColor(red: 0.325, green: 0.792, blue: 0.714, alpha: 1)
                textField.secureTextEntry = true
            }
            self.presentViewController(changePassword, animated: true, completion: nil)
            
            
        default:
            println("Noting vaild selected")
            
        }
        
    }
    
    
}