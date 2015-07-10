//
//  BeerTableViewCell.swift
//  
//
//  Created by Tyler Miller on 6/23/15.
//
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var breweryName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var breweryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        breweryImage.frame = CGRectMake(0, 0, 100, 100)
        breweryImage.layer.borderWidth = 2
        breweryImage.layer.masksToBounds = false
        breweryImage.layer.borderColor = UIColor.whiteColor().CGColor
        breweryImage.layer.cornerRadius = 15
        breweryImage.clipsToBounds = true
        
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
