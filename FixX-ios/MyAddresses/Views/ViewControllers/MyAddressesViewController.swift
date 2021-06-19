//
//  MyAddressesViewController.swift
//  FixX-ios
//
//  Created by Esraa Gohar on 6/19/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class MyAddressesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myAddressesTableView: UITableView!
    
    var addresses = [String]()
    var titles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addresses.append("add1")
        addresses.append("add2")
        titles.append("title1")
        titles.append("title2")

        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAddressesTableViewCell

        // Configure the cell...
        
        cell.addressLabel.text = addresses[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alert = UIAlertController(title: "Confirm deleting address", message: "Do you want to delete this address?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!) in
                
                addresses.remove(at: indexPath.row)
                titles.remove(at: indexPath.row)
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
    
   
    
  
    
    @IBAction func addAddressActionBtn(_ sender: Any) {
        let addAddressVC = self.storyboard?.instantiateViewController(identifier: "ADVC") as! AddAddressViewController
        
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
}
