//
//  OngoingOrdersViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class OngoingOrdersViewController: UIViewController {

    @IBAction func shit(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "myOrdersVC")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension OngoingOrdersViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongoingOrdersCell", for: indexPath)
        
        return cell
    }
    
    
}
