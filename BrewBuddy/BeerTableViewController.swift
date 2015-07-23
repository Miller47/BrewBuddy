//
//  BeerTableViewController.swift
//
//
//  Created by Tyler Miller on 6/13/15.
//
//

import UIKit
import Haneke
import CoreLocation
import Parse



class BeerTableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    private let APIKey = "46fdb18ac2e65c0422cdd01a915d63cb"
    var breweries: [Breweries] = []
    
    //Location var/let
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D!
    // UISearchController
    var suggestionsController = UISearchController()
    var results: [Breweries] = []
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //check for currrent user
        var currentUser = PFUser.currentUser()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if currentUser == nil {
            //Show Login
            
            let VC = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let parentView = self.parentViewController?.tabBarController {
                    parentView.presentViewController(VC, animated: true, completion: nil)
                } else {
                    self.presentViewController(VC, animated: true, completion: nil)
                }
            })
            
        } else {
            //set location manager
            locationManager.delegate = self
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                if breweries.count == 0 {
                    locationManager.startUpdatingLocation()
                }
            }
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(title: "", style: .Plain
            , target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        //set up pull to refres
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresh)
        
        
        configureTableView()
        configureSearch()
        
    }
    
    func handleRefresh(refresh: UIRefreshControl) {
        //refreshes data based on current location
        locationManager.startUpdatingLocation()
        //stops refrehing control
        refresh.endRefreshing()
    }
    
    
    func retriveBreweies(lat: Double, long: Double) {
        let breweryService =  BreweryService(APIKey: APIKey)
        breweryService.getBreweries(lat, long: long) {
            (let brew) in
            if let info = brew {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //set an array with the vcaules from the api
                    self.breweries = info.breweries
                    println("Number of Breweries: \(self.breweries.count)")
                    
                    
                    self.tableView.reloadData()
                    //scroll to top of tableView
                    self.tableView.setContentOffset(CGPointZero, animated: true)
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                })
            }
        }
        
    }
    
    // MARK: - CLLocationManager
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        
        let locationIssueController = UIAlertController(title: "Error", message: "Unable to get location data. Please check weather airplane mode is on!", preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        locationIssueController.addAction(okButton)
        self.presentViewController(locationIssueController, animated: true, completion: nil)
        
        
        
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locValue = manager.location.coordinate
        var long = locValue.longitude
        var lat = locValue.latitude
        
        locationManager.stopUpdatingLocation()
        
        println("didUpdateLocations:  \(lat), \(long)")
        
        SVProgressHUD.showWithStatus("Retrieving breweries nearby")
        showNetworkActivityIndicator(true)
        
        retriveBreweies(lat, long: long)
        
    }
    
    func getLatAndLong(location: String) {
        
        
        let geoCoder = CLGeocoder()
        
        
        geoCoder.geocodeAddressString(location, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("Geocde faile with error: \(error.description)")
            } else if placemarks.count > 0 {
                let placemark = placemarks[0] as! CLPlacemark
                let loc = placemark.location
                let lat = loc.coordinate.latitude
                let long = loc.coordinate.longitude
                println(loc)
                
                self.retriveBreweies(lat, long: long)
                SVProgressHUD.showWithStatus("Retrieving breweries near desired location")
            }
        })
        
        
    }
    
    // MARK: - UISearchBar
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // filter brewerery results based on user input
        results.removeAll(keepCapacity: false)
        
        
        var array = breweries.filter() {
            ($0.name!.lowercaseString as NSString).containsString(searchController.searchBar.text.lowercaseString)}
        
        results = array
        
        println("Array has \(array.count) elements")
        for brewery in array {
            println(brewery.name)
        }
        
        tableView.reloadData()
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text.isEmpty {
            
            searchBar.text = nil
            suggestionsController.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        results.removeAll()
        
    }
    
    func configureSearch() {
        
        
        suggestionsController = UISearchController(searchResultsController: nil)
        suggestionsController.searchResultsUpdater = self
        suggestionsController.dimsBackgroundDuringPresentation = false
        suggestionsController.hidesNavigationBarDuringPresentation = false
        suggestionsController.searchBar.tintColor = UIColor.whiteColor()
        suggestionsController.searchBar.returnKeyType = .Done
        suggestionsController.searchBar.placeholder = "Filter breweries"
        suggestionsController.searchBar.sizeToFit()
        suggestionsController.searchBar.delegate = self
        
        
        self.navigationItem.titleView = suggestionsController.searchBar
        
        self.definesPresentationContext = true
        
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if breweries.count != 0 {
            self.tableView.backgroundView = nil
            return 1
        } else {
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "No data was available, this likely means there are no breweries in your area. Sorry!"
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if suggestionsController.active {
            return results.count
        } else {
            return breweries.count
        }
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BeerTableViewCell
        
        if suggestionsController.active {
            
            let brewery = results[indexPath.row]
            
            if let name = brewery.name {
                cell.breweryName.text = name
            }
            
            if let dis = brewery.distance {
                
                cell.distance.text = "\(dis)"
            } else {
                cell.distance.text = "N/A"
            }
            if brewery.largeIconURL != nil {
                if let iconURL = NSURL(string: brewery.largeIconURL!) {
                    cell.breweryImage.hnk_setImageFromURL(iconURL)
                    println(iconURL)
                }
            } else {
                cell.breweryImage.image = UIImage(named: "brewbuddy")
            }
            
            
        } else {
            
            
            let brewery = breweries[indexPath.row]
            
            if let name = brewery.name {
                cell.breweryName.text = name
            }
            
            if let dis = brewery.distance {
                
                cell.distance.text = "\(dis)"
            } else {
                cell.distance.text = "N/A"
            }
            if brewery.largeIconURL != nil {
                if let iconURL = NSURL(string: brewery.largeIconURL!) {
                    cell.breweryImage.hnk_setImageFromURL(iconURL)
                    println(iconURL)
                }
            } else {
                cell.breweryImage.image = UIImage(named: "brewbuddy")
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
                
                if suggestionsController.active {
                    
                    if let row = self.tableView.indexPathForSelectedRow()?.row {
                        if let phone = results[row].phone {
                            VC.phoneNum = phone
                            
                        }
                        if let name = results[row].name {
                            VC.nameText = name
                        } else {
                            VC.nameText = "Not Avaliable"
                        }
                        if let website = results[row].website {
                            VC.websiteURL = website
                        }
                        if let loc = results[row].streetAddress, let state = breweries[row].region, let city = breweries[row].locality {
                            VC.loc = loc + " " + city + ", " + state
                        } else {
                            VC.loc = "Not Avaliable"
                        }
                        if let image = results[row].largeIconURL {
                            VC.imageURL = image
                        } else {
                            VC.imageURL = nil
                        }
                        if let id = results[row].breweryId {
                            VC.breweryId = id
                        }
                        
                    }
                } else {
                    
                    if let row = self.tableView.indexPathForSelectedRow()?.row {
                        if let phone = breweries[row].phone {
                            VC.phoneNum = phone
                            
                        }
                        if let name = breweries[row].name {
                            VC.nameText = name
                        } else {
                            VC.nameText = "Not Avaliable"
                        }
                        if let website = breweries[row].website {
                            VC.websiteURL = website
                        }
                        if let loc = breweries[row].streetAddress, let state = breweries[row].region, let city = breweries[row].locality {
                            VC.loc = loc + " " + city + ", " + state
                        } else {
                            VC.loc = "Not Avaliable"
                        }
                        if let image = breweries[row].largeIconURL {
                            VC.imageURL = image
                        } else {
                            VC.imageURL = nil
                        }
                        if let id = breweries[row].breweryId {
                            VC.breweryId = id
                        }
                
                    }
                }
            }
            
        }
    }
    
    
}
