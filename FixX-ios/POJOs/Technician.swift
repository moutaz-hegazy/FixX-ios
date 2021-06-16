//
//  Technician.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

struct Technician : Codable{
    var phoneNumber : String
    var accountType : String
    var name : String
    var email : String
    var uid : String?
    var token : String?
    var profilePicture : StringPair?
    var loactions : [String]?
    var jobTitle: String?
    var workLocations: [String]?
    var rating: Double?
    var monthlyRating: Int?
    var jobsCount : Int = 0
    var reviewCount:Int = 0
}
