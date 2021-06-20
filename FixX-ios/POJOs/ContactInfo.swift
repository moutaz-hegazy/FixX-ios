//
//  ContactInfo.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class ContactInfo : Codable{
    var uid : String?
    var channel : String?
    
    init() {}
    init(uid : String?, channel : String?) {
        self.uid = uid
        self.channel = channel
    }
}
