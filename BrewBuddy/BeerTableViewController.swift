//
//  BeerTableViewController.swift
//
//
//  Created by Tyler Miller on 6/13/15.
//
//

import UIKit
import Haneke


class BeerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let APIKey = "46fdb18ac2e65c0422cdd01a915d63cb"
    var breweries: [Breweries] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(title: "", style: .Plain
            , target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        configureTableView()
        retriveBreweies(35.772096, long: -78.638614)
        
        
        
    }
    
    func retriveBreweies(lat: Double, long: Double) {
        let breweryService =  BreweryService(APIKey: APIKey)
        breweryService.getBreweries(lat, long: long) {
            (let brew) in
            if let info = brew {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //set an array with the vcaules from the api
                    self.breweries = info.breweries
                    println(self.breweries.count)
                    
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return breweries.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BeerTableViewCell
        
        //Configure the cell...
        let brewery = breweries[indexPath.row]
        cell.breweryName.text = brewery.name
        cell.distance.text = "\(brewery.distance!)"
        if brewery.iconURL != nil {
            if let iconURL = NSURL(string: brewery.iconURL!) {
                cell.breweryImage.hnk_setImageFromURL(iconURL)
                println(iconURL)
            }
        } else {
            cell.breweryImage.image = UIImage(named: "miller-apps")
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
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowDetails") {
            
            
            
            if let VC: DetailViewController = segue.destinationViewController as? DetailViewController{
                
                
                if let row = self.tableView.indexPathForSelectedRow()?.row {
                    // VC.nameText = berweries[row]
                    println("row \(row) was selected")
                    // println("value \(berweries[row])")
                }
            }
            
        }
    }
    
    
}
