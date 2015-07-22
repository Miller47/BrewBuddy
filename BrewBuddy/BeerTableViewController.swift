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
import MapKit
import Parse



class BeerTableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    private let APIKey = "46fdb18ac2e65c0422cdd01a915d63cb"
    var breweries: [Breweries] = []
    
    //Location var/let
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D!
    // UISearchController
    var suggestionsController = UISearchController()
    var sugesstionResults: UITableViewController?
    var results: [AnyObject] = []
    
    
    
    
    
    
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
        results.removeAll()
        let placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.Geocode
        var query = searchController.searchBar.text
        
        
        if count(query) > 0 {
            println("Searching for: \(query)")
            placesClient.autocompleteQuery(query, bounds: nil , filter: filter, callback: { (result, error) -> Void in
                if error != nil {
                    println("Autocomplete error \(error)")
                    //return
                }
                
                if let data = result {
                    for resultData in data {
                        if let result = resultData as? GMSAutocompletePrediction {
                            
                            
                            placesClient.lookUpPlaceID(result.placeID, callback: { (place: GMSPlace?, erro: NSError?) -> Void in
                                if error != nil {
                                    println("Error getting place")
                                }
                                if let placeData = place {
                                    self.results.append(placeData)
                                    
                                    
                                    
                                }
                            })
                        }
                    }
                    
                   self.sugesstionResults?.tableView.reloadData()
                }
                
            })
        }
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text.isEmpty {
            let term =  searchBar.text
            getLatAndLong(term)
            //remove sugeestiongs tableview
            suggestionsController.dismissViewControllerAnimated(true, completion: nil)
            searchBar.text = nil
            results.removeAll()
            self.sugesstionResults?.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        results.removeAll()
        self.sugesstionResults?.tableView.reloadData()
        println("Canceled: \(results)")
    }
    
    func configureSearch() {
        
        // A table for search results and its controller.
        let resultsTableView = UITableView(frame: self.tableView.frame)
        sugesstionResults = UITableViewController()
        sugesstionResults?.tableView = resultsTableView
        sugesstionResults?.tableView.dataSource = self
        sugesstionResults?.tableView.delegate = self
        sugesstionResults?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //set up footer
        let poweredBy = UIImage(named: "powered-by-google-on-white")
        var imageView = UIImageView(image: poweredBy)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        sugesstionResults?.tableView.tableFooterView = imageView
        
        
        suggestionsController = UISearchController(searchResultsController: sugesstionResults)
        suggestionsController.searchResultsUpdater = self
        suggestionsController.dimsBackgroundDuringPresentation = false
        suggestionsController.hidesNavigationBarDuringPresentation = false
        suggestionsController.searchBar.tintColor = UIColor.whiteColor()
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
        if tableView == sugesstionResults?.tableView {
            return results.count
        } else {
            return breweries.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        if tableView == sugesstionResults?.tableView {
            
            
            if let address = results[indexPath.row].formattedAddress {
                cell.textLabel?.text = address
            }
            
            
            
        } else {
            
            let cell = cell as! BeerTableViewCell
            
            //Configure the cell...
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == self.sugesstionResults?.tableView {
            if let locationString = results[indexPath.row].formattedAddress {
                suggestionsController.searchBar.text = locationString
            } else {
                SVProgressHUD.showErrorWithStatus("Sorry could not get coorinaties")
            }
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowDetails") {
            
            
            
            if let VC: DetailViewController = segue.destinationViewController as? DetailViewController{
                
                
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
                    println("row \(row) was selected")
                    // println("value \(berweries[row])")
                }
            }
            
        }
    }
    
    
}
