//
//  SettingsScreenTableViewController.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/14/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SettingsScreenTableViewController: UITableViewController {
    
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    //    var str : String?
//    override func viewDidAppear(_ animated: Bool) {
//        Name.text = str

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.text = HomeScreenViewController.USER_OBJECT?.name
        
        if let pic = HomeScreenViewController.USER_OBJECT?.profilePicture, !pic.second.isEmpty{
            profileLbl.isHidden = true
            profileImage.sd_setImage(with: URL(string: pic.second), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            print("no image")
            profileLbl.layer.masksToBounds = true
            profileLbl.text = HomeScreenViewController.USER_OBJECT?.name.first?.uppercased()
        }
    }

    // MARK: - Table view data source
    /*

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 126
        }
        
        if (HomeScreenViewController.USER_OBJECT?.accountType == "User"){
            if (indexPath.row == 1 || indexPath.row == 4) {
                return 0
            }
        }
        
        return 82
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("you selected \(indexPath.row)")
        
        if(indexPath.row == 6){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()

                if let regVC = UIStoryboard(name: "Registration", bundle: nil).instantiateViewController(identifier: "regVC") as? RegistrationViewController{
                    regVC.modalPresentationStyle = .fullScreen
                    present(regVC, animated: true)
                }            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
