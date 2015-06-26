//
//  DetailViewController.swift
//  
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit
import Parse


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var nameText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = nameText
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postReview(sender: AnyObject) {
        
        var currentUser = PFUser.currentUser()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if currentUser == nil {
            //Show Login
            
            let VC = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            
            self.presentViewController(VC, animated: true, completion: nil)
        } else {
            
            let VC = storyBoard.instantiateViewControllerWithIdentifier("ReviewViewController") as! UIViewController
            let formSheetController = MZFormSheetPresentationController(contentViewController: VC)
            formSheetController.shouldDismissOnBackgroundViewTap = true
            formSheetController.shouldApplyBackgroundBlurEffect = true
            formSheetController.shouldCenterVertically = true
            formSheetController.contentViewSize = CGSizeMake(250, 250)
            
            self.presentViewController(formSheetController, animated: true, completion: nil)
            
        }
        
            }
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser .logOut()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! ReviewTableViewCell
        
        //Configure the cell...
        //cell.breweryName.text = "test"
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.918,  green:0.894,  blue:0.886, alpha:0.85)
        } else {
            cell.backgroundColor = UIColor(red:0.929,  green:0.922,  blue:0.918, alpha:0.85)
        }
    }


//    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//      
//
//    }


}
