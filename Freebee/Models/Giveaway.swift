//
//  Giveaway.swift
//  Freebee
//
//  Created by Anthony on 5/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class Giveaway {
    
    // Properties
    var giveawayID: String
    var active: Bool
    var name: String
    var cost: String
    var image: String
    var dateClosing: String // Need to change to date
    var details: String
    var category: String
    var shareEntries: [String]
    var adEntries: [String]
    var winnerChosen: Bool
    var winner: String
    var code: String
    var location: String
    var advertiserID: String
    var advertiserName: String
    
    init?(giveawayID: String, name: String,cost: String, image: String, dateClosing: String, details: String, category: String, shareEntries: [String], adEntries: [String], location: String, advertiserID: String, advertiserName: String){
        
        if name.isEmpty{
            return nil
        }
        
        self.giveawayID = giveawayID
        self.active = true
        self.name = name
        self.cost = cost
        self.image = image
        self.dateClosing = dateClosing
        self.details = details
        self.category = category
        self.shareEntries = shareEntries
        self.adEntries = adEntries
        self.winnerChosen = false
        self.winner = ""
        self.code = ""
        self.location = location
        self.advertiserID = advertiserID
        self.advertiserName = advertiserName
    }
    
}
