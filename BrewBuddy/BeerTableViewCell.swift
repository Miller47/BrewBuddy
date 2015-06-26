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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
