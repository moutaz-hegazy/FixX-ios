//
//  OngoingJobsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/22/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class OngoingJobsViewController: UIViewController {

    @IBOutlet weak var ongoingJobsTableView: UITableView!
    
    private var ongoingJobs = [Job]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirestoreService.shared.fetchMyOngoingWork { [weak self](jobs) in
            self?.ongoingJobs = jobs
            self?.ongoingJobsTableView.reloadData()
        } onFailHandler: {
            
        }

    }

}

extension OngoingJobsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongoingOrdersCell", for: indexPath)
        
        if let ongoingJobCell = cell as? OngoingTableViewCell{
            ongoingJobCell.viewJobOnCell(for: ongoingJobs[indexPath.row])
        }
        
        return cell
    }
    
    
}
