//
//  ViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/13/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var handle : AuthStateDidChangeListenerHandle?

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let c = Comment(username: "nnnn", commentContent: "nnn", profilePicture: nil, date: nil, reply: nil, timestamp: 12345, rating: nil)
        
        let mirror = Mirror(reflecting: c)
        _ = [mirror.children.compactMap { $0.label} : mirror.children.compactMap { $0.value}]
        
        
        _ = Mirror(reflecting: c)
        _ = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
              guard let label = label else { return nil }
              return (label, value)
            }).compactMap { $0 })
    
        //print(dictionary)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("state changed >>>>\(String(describing: user?.email))")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let email = emailTxt.text ?? ""
        let password = passwordTxt.text ?? ""
        if(!email.isEmpty && !password.isEmpty){
            /*Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let er = error{
                    print("ERROR >> \(er.localizedDescription)")
                }else{
                    print("SIGNED UP")
                }
            }*/
            
            FirestoreService.shared.registerUser(email: email, password: password, onSuccesshandler: {
                print("SIGNED UP")
            }, onFailHandler: {
                print("ERROR")
            })
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = emailTxt.text ?? ""
        let password = passwordTxt.text ?? ""
        if(!email.isEmpty && !password.isEmpty){
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                if let er = error{
                    print("ERROR >> \(er.localizedDescription)")
                }else{
                    print("LOGGEDIN")
                    /*FirestoreService.shared.fetchUserFromDB(uid: Auth.auth().currentUser?.uid, onCompletion: { user in
                        print("HELLLOOOOO \(String(describing: (user as? Technician)))")
                    }, passRegister: {_ in })*/
                    /*FirestoreService.shared.fetchUserOnce(onCompletion: {user in
                        print("HELLLOOOOO\(String(describing: user as? Technician))")
                    })*/
                    /*FirestoreService.shared.fetchCommentsForTech(onSuccessHandler: {comments in
                        print("\(comments)")}, onFailHandler: {})*/
                    //let ext = Extension(extId: nil, images: nil, description: "llll", price: nil)
                    
                    /*FirestoreService.shared.addExtensionToJob(jobId: "7ZvLQI4cPK1im9BwO0L4", ext: ext, onSuccessHandler: { extensions in
                        print("extension ::: \(extensions.extId)")
                    }, onFailHandler: {})*/
                    /*FirestoreService.shared.updateExtensionPrice(jobId: "7ZvLQI4cPK1im9BwO0L4", extId: "rjkfXVP7SeHlaVUHuTkE", price: 5, onSuccessHandler: {
                        print("updated")
                    }, onFailHandler: {
                        print("failed")
                    })*/
                    //FirestoreService.shared.removeExtension(jobId: "7ZvLQI4cPK1im9BwO0L4", extId: "rjkfXVP7SeHlaVUHuTkE", onSuccessHandler: {}, onFailHandler: {})
                    /*FirestoreService.shared.fetchExtensionsForJob(jobId: "bU87MiEEa2BRztWM7f8D", onSuccessHandler: {extensions in
                        print("extensions fetching : \(extensions.count)")
                    }, onFailHandler: {})*/
                    /*FirestoreService.shared.fetchChatUsersTest(onCompletion: {contacts in
                        print("\(contacts.count)")
                    })*/

                    
                    var ch = ChatMessage()
                    ch.text = "nohaaaaaa"
                    ch.fromId = "1"
                    ch.timestamp = 45454
                    //FirestoreService.shared.sendChatMessageTest(channel: "di6KGuxvSHYh2wCclKkciDp8H2B2-u2QpkWQ0ahNpL8Vw1tLz4BnUj673", msg: ch)
                    
                    /*FirestoreService.shared.fetchChatHistoryForChannelTest(channelName: "di6KGuxvSHYh2wCclKkciDp8H2B2-u2QpkWQ0ahNpL8Vw1tLz4BnUj673", observerHandler: { chat in
                        print("chat ::: \(chat.text)")
                    }, chatRegHandler: {})*/
                    /*FirestoreService.shared.fetchChatHistoryForInstanceTest(contact: "xx", observerHandler: {chat in
                        print("chat for instance \(chat.text)")
                    }, onCompletion: { channel in
                        print("channel :  \(channel)")
                        FirestoreService.shared.sendChatMessageTest(channel: channel, msg: ch)
                    }, chatRegHandler: {_ in})*/
                    
                    
                    //var c = Comment(username: "nnnn", commentContent: "nnn", profilePicture: nil, date: nil, reply: nil, timestamp: 12345, rating: nil)
                   // FirestoreService.shared.addRatingAndComment(techId: "di6KGuxvSHYh2wCclKkciDp8H2B2", rating: 2.0, extraRating: 2.0, comment: c, reviews: 0, onSuccessHandler: {}, onFailHandler: {})
                    
                }
            }
        }
    }
}

