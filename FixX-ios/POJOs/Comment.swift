//
//  Comment.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

struct Comment : Codable {
    var username : String = ""
    var commentContent : String?
    var profilePicture : String?
    var date : String?
    var reply : String?
    var timestamp : Int64?
    var rating : Double?
}

struct CommentData : Codable {
    var comment : Comment?
}

