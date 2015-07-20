//
//  SignUpViewController.swift
//
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if (username.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Make sure all fileds are filled out!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            SVProgressHUD.showWithStatus("Signing Up")
            self.showNetworkActivityIndicator(true)
            var user = PFUser()
            user.username = username.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            user.password = password.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            user.email = email.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                } else {
                    // Hooray! Let them use the app now.
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                    self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }
    
}
