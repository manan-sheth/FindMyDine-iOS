//
//  LocationCell.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

final class LocationCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    func configureCell(objCity: CityData) {
        
        self.lblLocation.text = objCity.title
        self.lblCity.text = objCity.city_name
    }
}
