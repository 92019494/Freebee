//
//  Giveaway.swift
//  Freebee
//
//  Created by Anthony on 5/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase

class Giveaway {
    
    // Properties
    var giveawayID: String
    var active: Bool
    var name: String
    var cost: String
    var image: String
    var dateClosing:  Timestamp
    var details: String
    var category: String
    var shareEntries: [String]
    var adEntries: [String]
    var winner: String
    var code: String
    var location: String
    var advertiserID: String
    var advertiserName: String
    
    init?(giveawayID: String, active: Bool, winner: String, name: String,cost: String, image: String, dateClosing: Timestamp, details: String, category: String, shareEntries: [String], adEntries: [String], location: String, code: String, advertiserID: String, advertiserName: String){
        
        if name.isEmpty{
            return nil
        }
        
        self.giveawayID = giveawayID
        self.active = active
        self.name = name
        self.cost = cost
        self.image = image
        self.dateClosing = dateClosing
        self.details = details
        self.category = category
        self.shareEntries = shareEntries
        self.adEntries = adEntries
        self.winner = winner
        self.code = code
        self.location = location
        self.advertiserID = advertiserID
        self.advertiserName = advertiserName
    }
    
}
