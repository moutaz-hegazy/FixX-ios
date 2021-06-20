//
//  Technician.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class Technician : Person{
    var jobTitle: String?
    var workLocations: [String]?
    var rating: Double?
    var monthlyRating: Int?
    var jobsCount : Int = 0
    var reviewCount:Int = 0
    
    init(jobTitle : String?, workLocations: [String]?, rating : Double?, monthlyRating : Int?, jobsCount : Int, reviewCount : Int, phoneNumber : String, accountType : String, name : String, email : String, uid : String?, token : String?, profilePicture : StringPair?, locations : [String]?) {
        self.jobTitle = jobTitle
        self.workLocations = workLocations
        self.rating = rating
        self.monthlyRating = monthlyRating
        self.jobsCount = jobsCount
        self.reviewCount = reviewCount
        super.init(phoneNumber: phoneNumber, accountType: accountType, name: name, email: email, uid: uid, token: token, profilePicture: profilePicture, locations: locations)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
