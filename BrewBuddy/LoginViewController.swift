//
//  LoginViewController.swift
//
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        if (userName.text.isEmpty || password.text.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Make sure all fileds are filled out!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            
            var user = userName.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            var pass = password.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
            PFUser.logInWithUsernameInBackground(user, password:pass) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // The login failed. Check error to see why.
                    let errorString = error!.userInfo?["error"] as? NSString
                    let alert = UIAlertController(title: "Error", message: "\(errorString)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            }
        }
        
    }
    
    @IBAction func forgotPass(sender: AnyObject) {
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! UIViewController
        
        self.presentViewController(VC, animated: true, completion: nil)
        
    }
    
    
    
}
