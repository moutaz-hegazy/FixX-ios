//
//  Job.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class Job : Codable{
    var uid: String?
    var type : String = ""
    //var status : JobStatus = JobStatus.OnRequest
    var status : String = "OnRequest"
    var jobId : String = ""
    var description : String = ""
    var date : String = ""
    var completionDate : String = ""
    var fromTime : String?
    var toTime : String?
    var price : Int?
    var techID : String?
    var bidders : [String : String]?
    var images : [StringPair]?
    var privateRequest : Bool = false
    
    var location : String?
    
    var areaLocation : String?
    var rateable : Bool = false
    var privateTechUid : String?

    
    init() {}
    init(uid: String?, type : String = "", location: String?,
         //status : JobStatus = JobStatus.OnRequest,
         status : String = "",
         jobId : String = "",
         description : String = "", date : String = "",
         completionDate : String = "", fromTime : String?, toTime : String?, price : Int?,
         techID : String?, bidders : [String : String]?, images : [StringPair]?,
         privateRequest : Bool = false){
        self.uid = uid
        self.type = type
        self.status = status
        self.jobId = jobId
        self.description = description
        self.date = date
        self.completionDate = completionDate
        self.fromTime = fromTime
        self.toTime = toTime
        self.price = price
        self.techID = techID
        self.bidders = bidders
        self.images = images
        self.privateRequest = privateRequest
        self.location = location
        print("location  >>>> \(location)")
        areaLocation = String(location![location!.firstIndex(of: "%")! ..< location!.firstIndex(of: "/")!])
        areaLocation?.removeFirst()
    }
    
//    enum JobStatus : CodingKey, Codable{
//        case OnRequest
//        case Accepted
//        case Completed
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: JobStatus.self)
//        }
//
//        init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: JobStatus.self)
//            _ = try values.decode(String.self, forKey: .OnRequest)
//            _ = try values.decode(String.self, forKey: .Accepted)
//            _ = try values.decode(String.self, forKey: .Completed)
//            self = try values.decode(JobStatus.self, forKey: .OnRequest)
//        }
//
//    }
}


//functions
