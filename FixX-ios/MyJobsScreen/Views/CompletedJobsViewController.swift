//
//  CompletedJobsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/22/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class CompletedJobsViewController: UIViewController {

    @IBOutlet weak var completedTableView: UITableView!
    
    private var completedJobs = [Job]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirestoreService.shared.fetchMyCompletedWork { [weak self](jobs) in
            self?.completedJobs = jobs
            self?.completedTableView.reloadData()
        } onFailHandler: {
            
        }

    }
}

extension CompletedJobsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedOrdersCell", for: indexPath)
        
        if let completedJobCell = cell as? CompletedTableViewCell{
            completedJobCell.viewJobOnCell(for: completedJobs[indexPath.row])
        }
        
        return cell
    }
    
}
