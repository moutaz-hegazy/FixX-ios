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
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let er = error{
                    print("ERROR >> \(er.localizedDescription)")
                }else{
                    print("SIGNED UP")
                }
            }
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
                }
            }
        }
    }
}

