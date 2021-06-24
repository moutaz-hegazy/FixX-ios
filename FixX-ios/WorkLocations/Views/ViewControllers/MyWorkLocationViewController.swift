//
//  MyWorkLocationViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/18/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit

class MyWorkLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myWorkLocationsTableView: UITableView!
    
    var addresses = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addresses = (HomeScreenViewController.USER_OBJECT as? Technician)?.workLocations ?? []
        myWorkLocationsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! MyWorkLocationsTableViewCell

        // Configure the cell...
        
        cell.addLbl.text = addresses[indexPath.row]

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alert = UIAlertController(title: "Confirm deleting work location", message: "Do you want to delete this work location?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!) in
                
                addresses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
               }))

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                       
                        alert .dismiss(animated: true, completion: nil)
               }))

                self.present(alert, animated: true, completion: nil)
            
            
              
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    @IBAction func addWorkLocationActionBtn(_ sender: Any) {
        
        let addWorkLocationVC = self.storyboard?.instantiateViewController(identifier: "AWLVC") as! AddWorkLocationViewController
        
        addWorkLocationVC.onWorkAddressAddedHandler = {
            [weak self](address) in
            self?.addresses.append(address)
            self?.myWorkLocationsTableView.reloadData()
        }
        
        self.present(addWorkLocationVC, animated: true, completion: nil)
    }

    @IBAction func backActionBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
