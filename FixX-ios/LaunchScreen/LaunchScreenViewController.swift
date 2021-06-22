//
//  LaunchScreenViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/21/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = FirestoreService.shared.auth.currentUser
        
        if(user != nil && user?.email != Constants.defaultEmail){
            FirestoreService.shared.fetchUserOnce { [weak self](person) in
                HomeScreenViewController.USER_OBJECT = person
                self?.dismiss(animated: true, completion: {
                    self?.startHomeScreen()
                })
            }
//            FirestoreService.shared.fetchUserFromDB { [weak self](person) in
//                HomeScreenViewController.USER_OBJECT = person
//                self?.dismiss(animated: true, completion: {
//                    self?.startHomeScreen()
//                })
//            } passRegister: { (observer) in
//                HomeScreenViewController.USER_OBSERVER = observer
//            }

        }else{
            FirestoreService.shared.logInWithDefault {
                [weak self] in
                print("wezza >>>> Here")
                self?.dismiss(animated: true, completion: {
                    self?.startRegisterScreen()
                })
            } onFail: {
                print("wezza >>>> Here2")
            }


        }
    }

    private func startHomeScreen(){
        if let homeVC = UIStoryboard(name: "TabBarStoryboard", bundle: nil).instantiateViewController(identifier: "tabBarVC") as? UITabBarController{
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    private func startRegisterScreen(){
        if let regVC = UIStoryboard(name: "Registration", bundle: nil).instantiateViewController(identifier: "regVC") as? RegistrationViewController{
            regVC.modalPresentationStyle = .fullScreen
            present(regVC, animated: true)
        }
    }
}
