//
//  ShowTechnicianTableViewController.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/17/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class ShowTechnicianTableViewController: UITableViewController {

    var technicians = [Technician]()
    var job : Job?
    var orderImagesUrls = [URL]()
    var onTechSelectedHandler : (()->())?
    var onDisplay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Technicians List"
        
        if let myJob = job{
            FirestoreService.shared.searchForTechnicianByJobAndLocation(job: myJob.type, location: myJob.areaLocation!) { [weak self](techs) in
                
                self?.technicians = techs
                self?.tableView.reloadData()
                
            }
        }
        
    }
    
    private func bookTechnician(with techData: Technician){
        if let jobRequested = job{
            jobRequested.privateTechUid = techData.uid
            uploadJob(job: jobRequested)
        }
    }
    
    private func uploadJob(job : Job){
        if orderImagesUrls.isEmpty{
            FirestoreService.shared.saveJobDetails(job: job) { (jobData) in
                self.onTechSelectedHandler?()
                self.navigationController?.popViewController(animated: true)
            } onFailHandler: {
                
            }
            
        }else{
            var imagesLinks = [StringPair]()
            for url in orderImagesUrls{
                FirestoreService.shared.uploadImagsToStorage(url) { [weak self](imagePair) in
                    imagesLinks += [imagePair]
                    if(imagesLinks.count == self?.orderImagesUrls.count ?? 0){
                        
                        job.images = imagesLinks
                        FirestoreService.shared.saveJobDetails(job: job) { (job) in
                            self?.onTechSelectedHandler?()
                            self?.navigationController?.popViewController(animated: true)
                            
                        } onFailHandler: {
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return technicians.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TechCell", for: indexPath) as! ShowTechnicianTableViewCell
        if(!onDisplay){
            cell.bookBtn.isHidden = true
        }
        cell.displayTechData(tech:technicians[indexPath.row])
        cell.techSelectedHandle = {
            [weak self] (techData) in
            guard let tech = techData else {
                return
            }
            self?.onDisplay = false
            self?.tableView.reloadData()
            self?.bookTechnician(with : tech)
            
        }
        

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShowTechnicianTableViewCell{
            openTechProfile(for: cell.techData)
        }
    }
    
    private func openTechProfile(for tech : Technician?){
        if let techVC = UIStoryboard(name: "TechnicianProfileStoryboard", bundle: nil)
            .instantiateViewController(identifier: "techProfileScreenVC") as? TechnicianProfileViewController ,let technician = tech{
            techVC.tech = technician
            techVC.job = job
            techVC.orderImagesUrls = orderImagesUrls
            techVC.displayOnly = false
            techVC.onBookHandler = {
                [weak self] in
                self?.onTechSelectedHandler?()
                self?.navigationController?.popViewController(animated: true)
            }
//            present(techVC, animated: true, completion: nil)
            navigationController?.pushViewController(techVC, animated: true)
        }
    }

}
