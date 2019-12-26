//
//  RestaurantCell.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

final class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    
    func configureCell(restaurant: RestaurantData) {
        
        self.lblName.text = restaurant.name
        self.lblAddress.text = restaurant.location?.address ?? "City"
        self.lblCost.text = "Average cost for 2 persons: \(restaurant.currency ?? "") \(restaurant.average_cost_for_two ?? 0)"
        self.lblVotes.text = "\(restaurant.user_rating?.votes ?? "0") Votes"
        self.lblRating.text = "\(restaurant.user_rating?.aggregate_rating ?? "0.0") / 5.0"
        
        if let rateValue = restaurant.user_rating?.rating_color, !rateValue.isEmpty {
            let hexColor = AppUtils.hexStringToUIColor(hex: "#\(rateValue)")
            self.lblRating.backgroundColor = hexColor
            self.lblRating.layer.cornerRadius = 5.0
            self.lblRating.clipsToBounds = true
        }
    }
}
