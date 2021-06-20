//
//  Person.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class Person : Codable{
    var phoneNumber : String = ""
    var accountType : String = ""
    var name : String = ""
    var email : String = ""
    var uid : String?
    var token : String?
    var profilePicture : StringPair?
    var locations : [String]?
    
    init() {}
    init(phoneNumber : String, accountType : String, name : String, email : String, uid : String?, token : String?, profilePicture : StringPair?, locations : [String]?) {
        self.phoneNumber = phoneNumber
        self.accountType = accountType
        self.name = name
        self.email = email
        self.uid = uid
        self.token = token
        self.profilePicture = profilePicture
        self.locations = locations
    }
}

