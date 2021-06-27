//
//  StringPair.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

struct StringPair : Codable{
    var first : String
    var second : String
    
    init(first : String = "", second : String = "") {
        self.first = first
        self.second = second
    }
    
    init(){
        first = ""
        second = ""
    }
}
