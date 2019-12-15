//
//  RestaurantCell.swift
//  Find My Dine
//
//  Created by Apple Customer on 14/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
