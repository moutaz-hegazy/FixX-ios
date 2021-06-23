//
//  AboutUsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var aboutLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutLabel.text = "- Fix-X is a repairmen application in Egypt where you can order fixers from different categories in maintenance and finishing.With a lot of registered fixers.\n- We know how hard it is to find a qualified fixer to get the job done.That is why Fix-X does all the hard work for you;we search,evaluate,and select the best fixers in all maintenance and finishing fields,and connect you with them flawlessly through our application.\n- With Fix-X you can easily choose your fixer based on previous customers ratings,location,and category.You can also leave your review too.\n- Our fixers are trained,punctual,and highly professional so you can stay safe and get high-quality services."
        

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
