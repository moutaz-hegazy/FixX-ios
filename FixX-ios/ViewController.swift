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
              guard let strongSelf = self else { return }
                if let er = error{
                    print("ERROR >> \(er.localizedDescription)")
                }else{
                    print("LOGGEDIN")
                    /*FirestoreService.shared.fetchUserFromDB(uid: Auth.auth().currentUser?.uid, onCompletion: { user in
                        print("HELLLOOOOO\(String(describing: user as! User))")
                    }, passRegister: {_ in })*/
                    /*FirestoreService.shared.fetchUserOnce(onCompletion: {user in
                        print("HELLLOOOOO\(String(describing: user as! User))")
                    })*/
                    /*FirestoreService.shared.fetchCommentsForTech(onSuccessHandler: {comments in
                        print("\(comments)")}, onFailHandler: {})*/
                    /*FirestoreService.shared.updateExtensionPrice(jobId: "7ZvLQI4cPK1im9BwO0L4", extId: "V2yYXn5dWdFC0gKmjzAn", price: 5, onSuccessHandler: {
                        print("updated")
                    }, onFailHandler: {
                        print("failed")
                    })*/
                    /*FirestoreService.shared.removeExtension(jobId: "7ZvLQI4cPK1im9BwO0L4", extId: "CXewSFMTCJQfmPeioX0c", onSuccessHandler: {}, onFailHandler: {})*/
                    /*FirestoreService.shared.fetchExtensionsForJob(jobId: "bU87MiEEa2BRztWM7f8D", onSuccessHandler: {_ in }, onFailHandler: {})*/
                    FirestoreService.shared.fetchChatUsersTest(onCompletion: {contacts in
                        print("\(contacts.count)")
                    })
                }
            }
        }
    }
}

