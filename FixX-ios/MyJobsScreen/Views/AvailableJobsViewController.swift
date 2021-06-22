//
//  AvailableJobsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/22/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class AvailableJobsViewController: UIViewController {

    @IBOutlet weak var availableJobsTableView: UITableView!
    
    private var availableJobs = [Job]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let techAcc = HomeScreenViewController.USER_OBJECT as? Technician{
            FirestoreService.shared.fetchAvailableWork(jobTitle: techAcc.jobTitle!, workLocations: techAcc.workLocations!) { [weak self](jobs) in
                self?.availableJobs = jobs
                self?.availableJobsTableView.reloadData()
            } onFailHandler: {
                
            }

        }
    }

}

extension AvailableJobsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongoingOrdersCell", for: indexPath)
        
        if let availableJobCell = cell as? OngoingTableViewCell{
            availableJobCell.viewJobOnCell(for: availableJobs[indexPath.row])
        }
        
        return cell
    }
    
    
}
