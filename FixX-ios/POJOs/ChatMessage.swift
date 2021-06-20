//
//  ChatMessage.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class ChatMessage {
    var text : String
    var fromId : String
    var timestamp : Int64
    
    init() {
        text = ""
        fromId = ""
        timestamp = -1
    }
    
    init(text : String, fromId : String, timestamp : Int64) {
        self.text = text
        self.fromId = fromId
        self.timestamp = timestamp
    }
}

