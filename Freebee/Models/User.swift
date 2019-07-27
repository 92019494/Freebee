//
//  User.swift
//  Freebee
//
//  Created by Anthony on 5/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class User {
    
    
    // Properties
    var user_id: Int
    var name: String
    var phone_number: String
    var address: String
    var city: String
    var age: Int
    var member_since: Date
    
    init?(user_id: Int, name: String, phone_number: String, address: String, city: String, age:Int, member_since: Date){
        
        if name.isEmpty || phone_number.isEmpty || address.isEmpty {
            return nil
        }
        
        self.user_id = user_id
        self.name = name
        self.phone_number = phone_number
        self.address = address
        self.city = city
        self.age = age
        self.member_since = member_since
        
    }
    
}
