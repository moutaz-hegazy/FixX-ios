//
//  ShowTechnicianViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit


class ShowTechnicianViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBAction func backButtonSheet(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var techTable: UITableView!
    
    var technicians = [Technician]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        techTable.delegate = self
        techTable.dataSource = self
        
        technicians = [Technician(techPhoto:"", techName: "Dina Adel", techRate: 3.5, noOfJobs: "4", noOfReviews: "2"),Technician(techPhoto: "", techName: "Esraa Gohar", techRate: 5, noOfJobs: "5", noOfReviews: "3")]

        // Do any additional setup after loading the view.
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return technicians.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TechCell", for: indexPath) as! ShowTechnicianTableViewCell
        
        let tech = technicians[indexPath.row]
        cell.TechRating.rating = tech.techRate
        cell.TechRating.settings.updateOnTouch = false
        cell.TechRating.settings.fillMode = .precise
        cell.TechRating.settings.starMargin = 1
        cell.TechName?.text = tech.techName
        cell.TechNoOfJobs?.text = tech.noOfJobs
        cell.TechNoOfReviews?.text = tech.noOfReviews
        //cell.TechImage?.image = tech.techPhoto

        // Configure the cell...

        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileTech = self.storyboard?.instantiateViewController(identifier:"ProfileVC") as! TechnicianProfileViewController
        
        profileTech.name = technicians[indexPath.row].techName
        profileTech.noOfJobs = technicians[indexPath.row].noOfJobs
        profileTech.noOfReviews = technicians[indexPath.row].noOfReviews
        profileTech.rating = technicians[indexPath.row].techRate
        profileTech.image = technicians[indexPath.row].techPhoto
        
        self.present(profileTech, animated: true, completion: nil)
    }
    
    
    struct Technician {
        let techPhoto : String
        let techName : String
        let techRate : Double
        let noOfJobs : String
        let noOfReviews : String
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
