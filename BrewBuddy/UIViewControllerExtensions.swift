//
//  UIViewControllerExtensions.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/18/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func showNetworkActivityIndicator(bool: Bool) {
        if bool {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func setBackBtnText() {
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
}
