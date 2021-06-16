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
    
    func registerUser(email : String,
                      password : String,
                      onSuccesshandler : @escaping ()-> Void,
                      onFailHandler : @escaping ()-> Void)
    {
        auth.createUser(withEmail: email, password: password){
    
            authResult, error in
            if error != nil{
                onFailHandler()
            }else{
                onSuccesshandler()
            }
        }
    }
    
    func fetchUserFromDB(uid : String? = shared.auth.currentUser?.uid,
                         onCompletion :@escaping (Any?) -> Void,
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
                    onCompletion(try? documentSnapshot?.data(as: User.self))
                case "Technician":
                    print("It is a Technician")
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
        
        
    func fetchUserOnce(uid : String? = shared.auth.currentUser?.uid, onCompletion :@escaping (Any?) -> Void){
        if let uid = uid{
            db.collection("Users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let type = document.get("accountType") as? String
                    switch type {
                    case "User":
                        print("It is a User")
                        onCompletion(try? document.data(as: User.self))
                    case "Technician":
                        print("It is a Technician")
                        onCompletion(try? document.data(as: Technician.self))
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
                if let err = err {
                    print("Error getting documents: \(err)")
                    onFailHandler()
                } else {
                    for document in querySnapshot!.documents {
                        let commentData = try? document.data(as: CommentData.self)
                        comments.append((commentData?.comment)!)
                    }
                    onSuccessHandler(comments)
                }
            }
    }
    
    
    func addExtensionToJob(jobId : String, ext : Extension,
                           onSuccessHandler : @escaping (Extension) -> Void,
                           onFailHandler : @escaping ()-> Void){
        let ref = db.collection("Jobs").document(jobId).collection("Extensions").document()
        let id = ref.documentID
           try? ref.setData(from: ext){ error in
            if error != nil {
                onFailHandler()
            } else{
                ref.updateData(["extId" : id]){
                    error in
                    if error != nil {
                        onFailHandler()
                    } else{
                        ext.extId = id
                        onSuccessHandler(ext)
                    }
                }
            }
        }
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
                try? snapshot.children.forEach{ contactSnapshot in
                    let value = (contactSnapshot as! DataSnapshot).value as? NSDictionary
                    let contact = ContactInfo()
                    contact.channel = value?["channel"] as? String ?? ""
                    contact.uid = value?["uid"] as? String ?? ""
                    contacts.append(contact)
                }
            }
            onCompletion(contacts)
        }
    }
}
