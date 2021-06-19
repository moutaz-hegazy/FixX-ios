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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        technicians = [Technician(techPhoto: UIImage(imageLiteralResourceName: "profile"), techName: "Dina Adel", techRate: 3.5, noOfJobs: "4", noOfReviews: "2"),Technician(techPhoto: UIImage(imageLiteralResourceName: "profile"), techName: "Esraa Gohar", techRate: 5, noOfJobs: "5", noOfReviews: "3")]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        let tech = technicians[indexPath.row]
        cell.TechRating.rating = tech.techRate
        cell.TechRating.settings.updateOnTouch = false
        cell.TechRating.settings.fillMode = .precise
        cell.TechRating.settings.starMargin = 1
        cell.TechName?.text = tech.techName
        cell.TechNoOfJobs?.text = tech.noOfJobs
        cell.TechNoOfReviews?.text = tech.noOfReviews
        cell.TechImage?.image = tech.techPhoto

        // Configure the cell...

        return cell
    }
    
    
    
    struct Technician {
        let techPhoto : UIImage
        let techName : String
        let techRate : Double
        let noOfJobs : String
        let noOfReviews : String
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
