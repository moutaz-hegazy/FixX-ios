//
//  SafetyTipsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class SafetyTipsViewController: UIViewController {

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var safetyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Make the most of your Fix-X visit"
        safetyLabel.text = "- Fix-X aims at excellence in services provided to its customers,those are Fix-X tips to help you enjoy our services even better.\n- Contracting Fix-X fixer outside the app voids your grantee and keeps you without any quality or cost control, so always use Fix-X for your repair needs.\n- We always make sure our fixers are honest and safe to let in your house, but your peace of mind always keep your personal belongings away from the fixing area.\n- Try having company when Fix-X fixers are at your home.\n- Fixing your home might involve dangerous materials and tools, so always keep your children away from Fix-X fixers gadgets and tools to ensure their safety.\n- Be in close proximity to the fixers, but try not to distract them with questions until the job is finished.\n- Please be sure about your order for Fix-X to enable us to serve you best, cancelling and no show is not welcome at Fix-X."

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
