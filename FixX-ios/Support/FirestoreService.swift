//
//  FirestoreService.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct FirestoreService{
    static let shared = FirestoreService()
    private init(){}
    
    var auth = Auth.auth()
    private var db = Firestore.firestore()
    //private var database = Database.database()
    private var contactsRef = Database.database().reference(withPath: "Contacts")
    private var chatsRef = Database.database().reference(withPath: "Chats")
    private let storageRef = Storage.storage().reference()
    
    
    func uploadImagsToStorage(_ imageUrl: URL,onSuccess handler : @escaping(StringPair)->()){
        let path = "Images/\(UUID().uuidString)"
        let imgRef = storageRef.child(path)
        imgRef.putFile(from: imageUrl, metadata: nil) { (mt, er) in
            if(er == nil){
                imgRef.downloadURL { (url, err) in
                    if let dUrl = url{
                        let pair  = StringPair(first: path,second: dUrl.absoluteString)
                        handler(pair)
                    }else{
                        print("wezza : Found nil")
                    }
                }
            }
        }
    }
    
    func registerUser(user:Person,
                      password : String,
                      onSuccesshandler : @escaping (Person?)-> Void,
                      onFailHandler : @escaping ()-> Void)
    {
        auth.createUser(withEmail: user.email, password: password){
    
            authResult, error in
            if error != nil{
                onFailHandler()
            }else{
                saveUserData(userData: user, onSuccessHandler: onSuccesshandler, onFailHandler: onFailHandler)
            }
        }
    }
    
    func fetchUserFromDB(uid : String? = shared.auth.currentUser?.uid,
                         onCompletion :@escaping (Person?) -> Void,
                         passRegister :@escaping (ListenerRegistration) -> Void){
        if let uid = uid{
            let registration = db.collection("Users").document(uid).addSnapshotListener{
                documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard document.data() != nil else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(documentSnapshot?.get("accountType") as? String ?? "") ")
                let type = documentSnapshot?.get("accountType") as? String
                switch type {
                case "User":
                    print("It is a User")
                    print("\(try? documentSnapshot?.data(as: User.self))")
                    onCompletion(try? documentSnapshot?.data(as: User.self))
                case "Technician":
                    print("It is a Technician")
                    print("\(try? documentSnapshot?.data(as: Technician.self))")
                    onCompletion(try? documentSnapshot?.data(as: Technician.self))
                case .none:
                    return
                case .some(_):
                    return
                }
            }
            passRegister(registration)
        }
    }
        
        
    func fetchUserOnce(uid : String? = shared.auth.currentUser?.uid, onCompletion :@escaping (Person?) -> Void){
        if let uid = uid{
            db.collection("Users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let type = document.get("accountType") as? String
                    switch type {
                    case "User":
                        onCompletion(try? document.data(as: User.self))
                    case "Technician":
                        let techData = try? document.data(as: Technician.self)
                        techData?.jobTitle = document.get("jobTitle") as? String
                        techData?.workLocations = document.get("workLocations") as? [String]
                        techData?.rating = document.get("rating") as? Double
                        techData?.monthlyRating = document.get("monthlyRating") as? Int
                        techData?.jobsCount = document.get("jobsCount") as? Int ?? 0
                        techData?.reviewCount = document.get("reviewCount") as? Int ?? 0
                        onCompletion(techData)

                    case .none:
                        return
                    case .some(_):
                        return
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func fetchCommentsForTech(techId : String = shared.auth.currentUser!.uid,
                              onSuccessHandler : @escaping ([Comment])-> Void,
                              onFailHandler : @escaping ()-> Void){
        var comments = [Comment]()
        db.collection("Users").document(techId).collection("Comments").order(by: "comment.timestamp", descending: true)
            .getDocuments{ (querySnapshot, err) in
                if err != nil{
                    onFailHandler()
                } else {
                    for document in querySnapshot!.documents {
                        let commentData = try? document.data(as: CommentData.self)
                        
                        if let comment = commentData?.comment?.commentContent,
                           !comment.isEmpty{
                            comments.append((commentData?.comment)!)
                        }
                    }
                    onSuccessHandler(comments)
                }
            }
    }
    
    
    func addExtensionToJob(jobId : String, ext : Extension,
                           onSuccessHandler : @escaping (Extension) -> Void,
                           onFailHandler : @escaping ()-> Void){
//        let ref = db.collection("Jobs").document(jobId).collection("Extensions").document()
//        let id = ref.documentID
//           try? ref.setData(from: ext){ error in
//            if error != nil {
//                onFailHandler()
//            } else{
//                ref.updateData(["extId" : id]){
//                    error in
//                    if error != nil {
//                        onFailHandler()
//                    } else{
//                        ext.extId = id
//                        onSuccessHandler(ext)
//                    }
//                }
//            }
//        }
    }
    
    func updateExtensionPrice(jobId: String, extId : String,price : Int,
                              onSuccessHandler: @escaping ()-> Void,
                              onFailHandler: @escaping ()->Void){
        db.collection("Jobs").document(jobId).collection("Extensions").document(extId)
            .updateData(["price" : price]){ err in
                if err != nil{
                    onFailHandler()
                } else{
                    onSuccessHandler()
                }
            }
    }
    
    func removeExtension(jobId : String, extId : String, onSuccessHandler : @escaping ()-> Void, onFailHandler : @escaping ()->Void){
        db.collection("Jobs").document(jobId).collection("Extensions").document(extId).delete(){ err in
            if err != nil{
                onFailHandler()
            } else{
                onSuccessHandler()
            }
        }
    }
    
    func fetchExtensionsForJob(jobId : String, onSuccessHandler : @escaping ([Extension]) -> Void,
                               onFailHandler : @escaping ()-> Void){
        var exts = [Extension]()
        db.collection("Jobs").document(jobId).collection("Extensions").getDocuments{
            (querySnapshot, err) in
            if err != nil {
                onFailHandler()
            } else{
                for document in querySnapshot!.documents {
                    let ext = try? document.data(as: Extension.self)
                    exts.append(ext!)
                }
                onSuccessHandler(exts)
            }
        }
    }
    
    func fetchChatUsersTest(onCompletion : @escaping ([ContactInfo])-> Void){
        var contacts = [ContactInfo]()
        contactsRef.child(auth.currentUser!.uid).observeSingleEvent(of: .value){ snapshot in
            if snapshot.exists(){
                snapshot.children.forEach{ contactSnapshot in
                    let value = (contactSnapshot as! DataSnapshot).value as? [String : Any]
                    let contact = ContactInfo()
                    contact.channel = value?["channel"] as? String ?? ""
                    contact.uid = value?["uid"] as? String ?? ""
                    contacts.append(contact)
                }
            }
            onCompletion(contacts)
        }
    }
    
    
    func fetchChatHistoryForChannelTest(channelName : String,
                                        observerHandler : @escaping (ChatMessage)->Void,
                                        chatRegHandler : @escaping (DatabaseReference)-> Void){
        let ref : DatabaseReference = chatsRef.child(channelName)
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if snapshot.exists(){
                let value = snapshot.value as? [String : Any]
                let msg = ChatMessage(text: value?["text"] as? String ?? "", fromId: value?["fromId"] as? String ?? "", timestamp: value?["timestamp"] as? Int64 ?? -1)
            
                observerHandler(msg)
            }
            chatRegHandler(ref)
        })
    }
    
    func fetchChatHistoryForInstanceTest(contact : String, observerHandler : @escaping (ChatMessage) -> Void,
                                         onCompletion : @escaping (String)-> Void,
                                         chatRegHandler : @escaping (DatabaseReference) -> Void){
        chatsRef.child("\(auth.currentUser!.uid)-\(contact)").observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists(){
                onCompletion("\(auth.currentUser!.uid)-\(contact)")
                fetchChatHistoryForChannelTest(channelName: "\(auth.currentUser!.uid)-\(contact)", observerHandler: observerHandler, chatRegHandler: chatRegHandler)
            } else{
                chatsRef.child("\(contact)-\(auth.currentUser!.uid)").observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists(){
                        onCompletion("\(contact)-\(auth.currentUser!.uid)")
                        fetchChatHistoryForChannelTest(channelName: "\(contact)-\(auth.currentUser!.uid)", observerHandler: observerHandler, chatRegHandler: chatRegHandler)
                    } else{
                        createChatChannel(channelName: "\(auth.currentUser!.uid)-\(contact)", contact: contact, msg: ChatMessage(text: "", fromId: auth.currentUser!.uid, timestamp: Int64(Date().timeIntervalSince1970)*1000), observerHandler: observerHandler, chatRegHandler: chatRegHandler)
                    }
                })
            }
        })
    }
    
    private func createChatChannel(channelName : String, contact : String, msg : ChatMessage,
                                   observerHandler : @escaping (ChatMessage) -> Void,
                                   chatRegHandler : @escaping (DatabaseReference) -> Void){
        let mirror = Mirror(reflecting: msg)
        let dictionary = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
              guard let label = label else { return nil }
              return (label, value)
            }).compactMap { $0 })
        chatsRef.child(channelName).childByAutoId().setValue(dictionary, withCompletionBlock: {error, databaseRef in
            if error == nil{
                let mirror = Mirror(reflecting: ContactInfo(uid: contact, channel: channelName))
                let dictionary = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
                      guard let label = label else { return nil }
                      return (label, value)
                    }).compactMap { $0 })
                
                contactsRef.child(auth.currentUser!.uid).child(contact).setValue(dictionary)
                databaseRef.observe(.childAdded, with: {dataSnapshot in
                    let value = (dataSnapshot as DataSnapshot).value as? [String : Any]
                    let msg = ChatMessage(text: value?["text"] as? String ?? "", fromId: value?["fromId"] as? String ?? "", timestamp: value?["timestamp"] as? Int64 ?? -1)
                    observerHandler(msg)
                })
                chatRegHandler(databaseRef)
            }
        })
    }
    
    
    func addNewChatContact(contactInfo : ContactInfo){
        contactsRef.child(auth.currentUser!.uid).child(contactInfo.uid!).observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if !snapshot.exists(){
                snapshot.ref.setValue(contactInfo)
            }
        })
    }
    
    func sendChatMessageTest(channel : String, msg : ChatMessage){
        let mirror = Mirror(reflecting: msg)
        let dictionary = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
              guard let label = label else { return nil }
              return (label, value)
            }).compactMap { $0 })
        
        chatsRef.child(channel).childByAutoId().setValue(dictionary)
    }
    
    func addRatingAndComment(techId : String, rating : Double, extraRating : Double,
                             comment : Comment, reviews : Int,
                             onSuccessHandler : @escaping ()-> Void,
                             onFailHandler : @escaping ()-> Void){
        
        let mirror = Mirror(reflecting: comment)
        let dictionary = Dictionary(uniqueKeysWithValues: mirror.children.lazy
                                        .map({ (label:String?, value:Any) -> (String, Any)? in
                guard let label = label else { return nil }
                return (label, value)
            }).compactMap { $0 })
        
        let dict = ["rating" : rating, "monthlyRating" : extraRating, "reviewCount" :reviews] as [String : Any]
        let ref = db.collection("Users").document(techId)
        ref.updateData(dict)
        ref.collection("Comments").document(auth.currentUser!.uid).getDocument{
            (document, error) in
            if let document = document, document.exists {
                document.reference.updateData(["comment" : dictionary]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        onFailHandler()
                    } else {
                        print("Document successfully updated")
                        onSuccessHandler()
                    }
                }
                    
            } else {
                document?.reference.setData(["comment" : dictionary]){err in
                        if err != nil{
                            onFailHandler()
                        } else {
                            onSuccessHandler()
                        }
                }
            }
        }
    }
    
//-------------------------------------------------------------------------------------------------------------------------------
    
    func addBidder(jobId : String, bidders : [String : String], onCompletion : @escaping ()-> Void){
        db.collection("Jobs").document(jobId).updateData(["bidders" : bidders], completion: { error in
            if error == nil{
                onCompletion()
            }
        })
    }
    
    func removeBidders(jobId : String){
        db.collection("Jobs").document(jobId).updateData(["bidders" : NSNull()])
    }
    
    func removeTechnicianFromJob(jobId : String){
        db.collection("Jobs").document(jobId).updateData(["techID" : NSNull(),
                                                          //"status" : Job.JobStatus.OnRequest.stringValue,
                                                          "status" : "OnRequest",
                                                          "price" : NSNull()])
    }
    
    func selectTechForJob(techId : String, jobId : String, price : String){
        db.collection("Jobs").document(jobId).updateData(["techID" : techId, "price" : Int(price), "bidders" : NSNull(),
                                                          //"status" : Job.JobStatus.Accepted.stringValue
                                                          "status" : "Accepted"])
    }
    
    func fetchJobById(jobId : String, onSuccessHandler : @escaping (Job) -> Void,
                      onFailHandler : @escaping ()-> Void){
        db.collection("Jobs").document(jobId).getDocument(completion: {snapshot, error in
            print("after in")
            if error != nil{
                onFailHandler()
            } else{
                if let snapshot = snapshot{
                    print("inside let")
                    onSuccessHandler(try! snapshot.data(as: Job.self) as! Job)
                }
            }
        })
    }
    
    func loginWithEmailAndPassword(email : String, password : String, onSuccessHandler : @escaping (Person?)-> Void,
                                   onFailHandler : @escaping ()-> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if error != nil{
               onFailHandler()
            }else{
                if email != "defaultaccount@default.com"{
                    fetchUserOnce { (person) in
                        onSuccessHandler(person)
                    }
                } else{
                    onFailHandler()
                }
            }
        }
    }
    
    func logInWithDefault (onCompletion : @escaping()->(), onFail : @escaping()->()){
        auth.signIn(withEmail: Constants.defaultEmail, password: Constants.defaultPassword) { (res, error) in
            if(error == nil){
                onCompletion()
            }else{
                onFail()
            }
        }
    }
    
    func saveJobDetails(job : Job, onSuccessHandler : @escaping (Job) -> Void, onFailHandler : @escaping () -> Void){
        let ref = db.collection("Jobs").document()

        do{
            try ref.setData(from: job, completion: { (err) in
                if err != nil{
                    onFailHandler()
                } else{
                    ref.updateData(["jobId" : ref.documentID])
                    job.jobId = ref.documentID
                    onSuccessHandler(job)
                }
            })
        }catch (let error){
            print("error happend >>> \(error.localizedDescription)")
        }
    }
    
    
    func saveUserData(userData : Any, onSuccessHandler : @escaping (Person?) -> Void, onFailHandler : @escaping ()-> Void){
        
        if let user = userData as? Person{
            user.uid = auth.currentUser!.uid as String
                let mirror = Mirror(reflecting: user)
                var dictionary = [String: AnyObject]()
                for (_, attr) in mirror.children.enumerated() {
                    if let propertyName = attr.label {
                        dictionary[propertyName] = attr.value as AnyObject
                    }
                }
            if let parent = mirror.superclassMirror{
                    for (_, attr) in parent.children.enumerated() {
                        if let propertyName = attr.label {
                            if dictionary[propertyName] == nil{
                                dictionary[propertyName] = attr.value as? AnyObject
                            }
                        }
                    }
                }

                db.collection("Users").document(auth.currentUser!.uid as String).setData(dictionary, completion: {error in
                    if error != nil{
                        onFailHandler()
                    } else{
                        onSuccessHandler(user)
                    }
                })
        }
    }
    
    func fetchMyOngoingOrderedJobs(onSuccessHandler : @escaping ([Job])-> Void, onFailureHandler : @escaping ()-> Void){
        var retrievedJobs = [Job]()
        db.collection("Jobs").whereField("uid", isEqualTo: auth.currentUser!.uid)
            //.whereField("status", in: [Job.JobStatus.OnRequest.stringValue, Job.JobStatus.Accepted.stringValue])
            .whereField("status", in: ["OnRequest", "Accepted"])
            .getDocuments(completion: {queryResult, error in
                if error != nil{
                    onFailureHandler()
                } else{
                    queryResult?.documents.forEach{ document in
                        if let job = try? document.data(as: Job.self){
                            retrievedJobs.append(job)
                        }
                    }
                    onSuccessHandler(retrievedJobs)
                }
            })
    }
    
    func removeLocation(location : String){
        db.collection("Users").document(auth.currentUser!.uid).updateData(["locations" : FieldValue.arrayRemove([location])])
    }
    
    
    func removeWorkLocation(location : String, onSuccessHandler : @escaping ()-> Void, onFailHandler : @escaping () -> Void){
        db.collection("Users").document(auth.currentUser!.uid).updateData(["workLocations": FieldValue.arrayRemove([location])], completion: {error in
            if error != nil{
                onFailHandler()
            } else{
                onSuccessHandler()
            }
        })
    }
    
    
    func removeJob(jobId : String, onSuccessHandler : @escaping ()-> Void, onFailHandler : @escaping ()-> Void){
        db.collection("Jobs").document(jobId).delete(completion: {error in
            if error != nil{
                onFailHandler()
            } else{
                onSuccessHandler()
            }
        })
    }
    
    
    func fetchMyCompletedOrderedJobs(onSuccessHandler : @escaping ([Job])-> Void, onFailHandler : @escaping ()-> Void){
        var retrievedJobs = [Job]()
        db.collection("Jobs").whereField("uid", isEqualTo: auth.currentUser!.uid)
           // .whereField("status", isEqualTo: Job.JobStatus.Completed.stringValue)
            .whereField("status", isEqualTo: "Completed")
            .getDocuments(completion: {queryResult, error in
                if error != nil{
                    onFailHandler()
                } else{
                    queryResult?.documents.forEach{ document in
                        if let job = try? document.data(as: Job.self){
                            retrievedJobs.append(job)
                        }
                    }
                    onSuccessHandler(retrievedJobs)
                }
            })
    }
    
    
    func fetchMyOngoingWork(onSuccessHandler : @escaping ([Job])-> Void, onFailHandler : @escaping ()-> Void){
        var retrievedJobs = [Job]()
        db.collection("Jobs").whereField("techID", isEqualTo: auth.currentUser!.uid)
            //.whereField("status", isEqualTo: Job.JobStatus.Accepted.stringValue)
            .whereField("status", isEqualTo: "Accepted")
            .getDocuments(completion: {queryResult, error in
                if error == nil{
                    queryResult?.documents.forEach{ document in
                        if let job = try? document.data(as: Job.self){
                            retrievedJobs.append(job)
                        }
                    }
                    db.collection("Jobs").whereField("privateRequest", isEqualTo: true)
                        //.whereField("status", isEqualTo: Job.JobStatus.OnRequest.stringValue)
                        .whereField("status", isEqualTo: "OnRequest")
                        .getDocuments(completion: {
                            snapshot, error in
                            if error == nil{
                                snapshot?.documents.forEach{ document in
                                    if let job = try? document.data(as: Job.self){
                                        retrievedJobs.append(job)
                                    }
                                    onSuccessHandler(retrievedJobs)
                                }
                            } else{
                                onSuccessHandler(retrievedJobs)
                            }
                        })
                    } else{
                    onFailHandler()
                }
            })
    }
    
    func fetchMyCompletedWork(onSuccessHandler : @escaping ([Job])-> Void, onFailHandler : @escaping ()-> Void){
        var retrievedJobs = [Job]()
        db.collection("Jobs").whereField("techID", isEqualTo: auth.currentUser!.uid)
            //.whereField("status", isEqualTo: Job.JobStatus.Completed.stringValue)
            .whereField("status", isEqualTo: "Completed")
            .getDocuments(completion: {queryResult, error in
                if error != nil{
                    onFailHandler()
                } else{
                    queryResult?.documents.forEach{ document in
                        if let job = try? document.data(as: Job.self){
                            retrievedJobs.append(job)
                        }
                    }
                    onSuccessHandler(retrievedJobs)
                }
            })
    }
    
    func fetchAvailableWork(jobTitle : String, workLocations : [String],
                            onSuccessHandler : @escaping ([Job])-> Void, onFailHandler : @escaping ()-> Void){
        var retrievedJobs = [Job]()
        db.collection("Jobs")
            //.whereField("status", isEqualTo: Job.JobStatus.OnRequest.stringValue)
            .whereField("status", isEqualTo: "OnRequest")
            .whereField("type", isEqualTo: jobTitle)
            .whereField("privateRequest", isEqualTo: false)
            .whereField("areaLocation", in: workLocations)
            .getDocuments(completion: {queryResult, error in
                if error != nil{
                    onFailHandler()
                } else{
                    queryResult?.documents.forEach{ document in
                        if let job = try? document.data(as: Job.self){
                            retrievedJobs.append(job)
                        }
                    }
                    onSuccessHandler(retrievedJobs)
                }
            })
    }
    
    func checkIfPhoneExists(phone : String, callback : @escaping (Bool) -> Void){
        db.collection("Users").whereField("phoneNumber", isEqualTo: phone).getDocuments(completion:{ result, error in
            if let res = result?.count{
                if res > 0{
                    callback(true)
                } else{
                    callback(false)
                }
            }
        })
    }
 
    func checkIfEmailExists(email : String, callback : @escaping (Bool) -> Void){
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments(completion:{ result, error in
            if let res = result?.count{
                if res > 0{
                    callback(true)
                } else{
                    callback(false)
                }
            }
        })
    }
    
    
    func searchForTechnicianByJobAndLocation(job: String, location: String, callback: @escaping ([Technician]) -> Void){
        var techniciansList = [Technician]()
        db.collection("Users").whereField("accountType", isEqualTo: "Technician")
            .whereField("jobTitle", isEqualTo: job)
            .whereField("workLocations", arrayContains: location.components(separatedBy: "%")[0])
            .getDocuments(completion: {snapshot, error in
                snapshot?.documents.forEach{ document in
                    let techData = try? document.data(as: Technician.self)
                    techData?.jobTitle = document.data()["jobTitle"] as? String
                    techData?.workLocations = document.data()["workLocations"] as? [String]
                    techData?.rating = document.data()["rating"] as? Double
                    techData?.monthlyRating = document.data()["monthlyRating"] as? Int
                    techData?.jobsCount = document.data()["jobsCount"] as? Int ?? 0
                    techData?.reviewCount = document.data()["reviewCount"] as? Int ?? 0
                    if let tech = techData{
                        if tech.uid != auth.currentUser!.uid{
                            techniciansList.append(tech)
                        }
                    }
                    
                }
                callback(techniciansList)
            })
    }
    

    func updateDocumentField(collectionName: String, fieldName: String, element: Any, documentId: String,
                             onSuccessHandler: @escaping () -> Void = {},
                             onFailHandler: @escaping () -> Void = {}){
        db.collection(collectionName).document(documentId).updateData([fieldName : element], completion: { error in
            if error != nil{
                onFailHandler()
            } else {
                onSuccessHandler()
            }
        })
    }
    
    func updateUserLocations(loc : String, onSuccessHandler: @escaping () -> Void, onFailHandler: @escaping () -> Void){
        db.collection("Users").document(auth.currentUser!.uid).updateData(["locations" : FieldValue.arrayUnion([loc])] , completion: {error in
            if error != nil{
                onFailHandler()
            } else{
                onSuccessHandler()
            }
        })
    }
    
    func updateWorkLocations(loc : String, onSuccessHandler: @escaping () -> Void, onFailHandler: @escaping () -> Void){
        db.collection("Users").document(auth.currentUser!.uid).updateData(["workLocations" : FieldValue.arrayUnion([loc])], completion: {error in
            if error != nil{
                onFailHandler()
            } else{
                onSuccessHandler()
            }
        })
    }
    
    func updateDocument(collectionName: String, map: [String : Any], documentId: String,
                        onSuccessHandler: @escaping () -> Void,
                        onFailureHandler: @escaping () -> Void){
        db.collection(collectionName).document(documentId).updateData(map, completion: {error in
            if error != nil{
                onFailureHandler()
            } else{
                onSuccessHandler()
            }
        })
    }
}
