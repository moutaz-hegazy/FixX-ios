//
//  User.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

struct User : Codable{
    var phoneNumber : String
    var accountType : String
    var name : String
    var email : String
    var uid : String?
    var token : String?
    var profilePicture : StringPair?
    var loactions : [String]?
}
/*class User(phoneNumber: String = "", accountType: String = "", name: String ="", email: String = "", uid : String = "")
    : Person(phoneNumber,accountType,name,email,uid)*/
