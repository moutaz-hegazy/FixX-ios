//
//  RatingViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/25/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {

    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var miniView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitPressed(_ sender: UIButton) {
        print("rating >>> \(ratingView.rating)")
        print("comment >> \(commentTxt.text ?? "none")")
    }
    @IBAction func viewTouched(_ sender: UITapGestureRecognizer) {
        let yLocation = sender.location(in: miniView).y
        
        if(yLocation < 0 || yLocation > 250){
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    

}
