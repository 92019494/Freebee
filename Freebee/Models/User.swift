//
//  User.swift
//  Freebee
//
//  Created by Anthony on 5/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase

class User {
    
    
    // Properties

    var name: String
    var phoneNumber: String
    var address: String
    var region: String
    var age: String
    var email: String
    
  init?(  name: String, phoneNumber: String, address: String, region: String, age:String, email:String){
        
        if name.isEmpty || phoneNumber.isEmpty || address.isEmpty {
            return nil
        }
        

        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.region = region
        self.age = age
        self.email = email
        
    }
    
}
