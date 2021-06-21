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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            [weak self] in
            if let homeVC = UIStoryboard(name: "HomeScreenStoryboard", bundle: nil).instantiateViewController(identifier: "homeVC")
                as? HomeScreenViewController{
                self?.present(homeVC, animated: true, completion: nil)
            }
        })
    }

}
