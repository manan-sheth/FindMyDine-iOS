//
//  LocationCell.swift
//  Find My Dine
//
//  Created by Apple Customer on 14/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
