//
//  CompletedOrdersViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class CompletedOrdersViewController: UIViewController {

    @IBOutlet weak var completedJobsTableView: UITableView!
    
    private var completedJobs = [Job]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCompletedOrders()

    }

    private func loadCompletedOrders(){
        FirestoreService.shared.fetchMyCompletedOrderedJobs { [weak self](jobs) in
            self?.completedJobs = jobs
            self?.completedJobsTableView.reloadData()
        } onFailHandler: {
            
        }
    }
}


extension CompletedOrdersViewController : UITableViewDelegate, UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let jobDetailsVC = UIStoryboard(name: "JobDetails", bundle: nil).instantiateViewController(identifier: "jobDetailsVC") as? JobDetailsViewController{
            
            jobDetailsVC.job = completedJobs[indexPath.row]
            jobDetailsVC.onLeaveHandler = {
                [weak self] in
                self?.loadCompletedOrders()
            }
            present(jobDetailsVC, animated: true, completion: nil)
        }
    }
    
}
