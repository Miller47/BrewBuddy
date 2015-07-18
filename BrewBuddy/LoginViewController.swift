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
            SVProgressHUD.showWithStatus("Logging in")
            showNetworkActivityIndicator(true)
            var user = userName.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            var pass = password.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            PFUser.logInWithUsernameInBackground(user, password:pass) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    self.dismissViewControllerAnimated(true, completion: nil)
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                } else {
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                    // The login failed. Check error to see why.
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        let alert = UIAlertController(title: "Error", message: "\(errorString!)", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
    }
    
    
    @IBAction func forgotPass(sender: AnyObject) {
        
        let passwordRest = UIAlertController(title: "Reset Password", message: "Plaese prodeive your email, in order to reset your password.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            
        }
        passwordRest.addAction(cancel)
        let reset = UIAlertAction(title: "Reset", style: .Default) { (action) -> Void in
            if let textField =  passwordRest.textFields?.first as? UITextField {
                if !(textField.text.isEmpty) {
                    SVProgressHUD.showWithStatus("Sending reset instructrions")
                    self.showNetworkActivityIndicator(true)
                    PFUser.requestPasswordResetForEmailInBackground(textField.text, block: { (pass: Bool, error: NSError?) -> Void in
                        if error == nil {
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
                        
                    })
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "Make sure you provide an email", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OKAY", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        passwordRest.addAction(reset)
        passwordRest.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.textColor = UIColor(red:0.325,  green:0.792,  blue:0.714, alpha:1)
        }
        
        self.presentViewController(passwordRest, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! UIViewController
        
        self.presentViewController(VC, animated: true, completion: nil)
        
    }
    
    
    
}
