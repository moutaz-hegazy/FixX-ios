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
    var onTechSelectedHandler : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            FirestoreService.shared.saveJobDetails(job:jobRequested) { (job) in
                self.onTechSelectedHandler?()
                self.navigationController?.popViewController(animated: true)
            } onFailHandler: {
                
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
        
        cell.displayTechData(tech:technicians[indexPath.row])
        cell.techSelectedHandle = {
            [weak self] (techData) in
            guard let tech = techData else {
                return
            }
            
            self?.bookTechnician(with : tech)
            
        }
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
