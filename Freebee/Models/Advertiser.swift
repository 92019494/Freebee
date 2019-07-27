//
//  Advertiser.swift
//  Freebee
//
//  Created by Anthony on 5/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class Advertiser {
    
    //Properties
    var advertiserID: Int
    var name: String
    var description: String
    var website: String
    var address: String
    var suburb: String
    var city: String
    var facebookShareLink: String
    
    init?(advertiserID: Int, name: String, description: String, website: String, address: String, suburb: String, city: String, facebookShareLink: String){
        
        if name.isEmpty || description.isEmpty || address.isEmpty
            || suburb.isEmpty || city.isEmpty {
            return nil
        }
        
        self.advertiserID = advertiserID
        self.name = name
        self.description = description
        self.website = website
        self.address = address
        self.suburb = suburb
        self.city = city
        self.facebookShareLink = facebookShareLink
        
    }
    
    
}
