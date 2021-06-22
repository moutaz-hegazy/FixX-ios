//
//  OngoingOrdersViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class OngoingOrdersViewController: UIViewController {
    
    @IBOutlet weak var ongoingOrdersTableView: UITableView!
    
    private var ongoingOrders = [Job]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirestoreService.shared.fetchMyOngoingOrderedJobs { (jobs) in
            self.ongoingOrders = jobs
            self.ongoingOrdersTableView.reloadData()
        } onFailureHandler: {
            
        }

    }

}


extension OngoingOrdersViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongoingOrdersCell", for: indexPath)
        
        if let ongoingCell = cell as? OngoingTableViewCell{
            ongoingCell.viewJobOnCell(for: ongoingOrders[indexPath.row])
        }
        
        return cell
    }
    
    
}
