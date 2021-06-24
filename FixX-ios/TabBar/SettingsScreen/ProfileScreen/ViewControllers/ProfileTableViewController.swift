//
//  ProfileTableViewController.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileTableViewController: UITableViewController {
    
    
    @IBOutlet weak var myName: UILabel!
    
    @IBOutlet weak var myEmail: UILabel!
    
    @IBOutlet weak var myPhone: UILabel!
    
    @IBOutlet weak var myPassword: UILabel!
    
    @IBOutlet weak var myProfileImage: UIImageView!
    
    @IBOutlet weak var myImageLbl: UILabel!
    
    @IBAction func chooseImage(_ sender: UIButton) {
        
        
    }
    @IBAction func EditName(_ sender: UIButton) {
        
        let editNameAlert = UIAlertController(title: "Edit Name", message: "Enter Your Name", preferredStyle: .alert)
        
        editNameAlert.addTextField()
        
        editNameAlert.textFields![0].placeholder = "Enter your name"
        editNameAlert.textFields![0].keyboardType = UIKeyboardType.alphabet
        
        editNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editNameAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let nameText = editNameAlert.textFields![0].text
            self.myName.text = nameText
        } ))
        
        self.present(editNameAlert, animated: true)
        
        
    }
    
    
    @IBAction func EditEmail(_ sender: UIButton) {
        let editEmailAlert = UIAlertController(title: "Edit Email", message: "Enter Your Email", preferredStyle: .alert)
        
        editEmailAlert.addTextField()
        
        editEmailAlert.textFields![0].placeholder = "Enter your email"
        editEmailAlert.textFields![0].keyboardType = UIKeyboardType.emailAddress
        
        editEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editEmailAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let emailText = editEmailAlert.textFields![0].text
            self.myEmail.text = emailText
        } ))
        
        self.present(editEmailAlert, animated: true)
    }
    
    @IBAction func EditPhone(_ sender: UIButton) {
        let editPhoneAlert = UIAlertController(title: "Edit Phone", message: "Enter Your Phone", preferredStyle: .alert)
        
        editPhoneAlert.addTextField()
        
        editPhoneAlert.textFields![0].placeholder = "Enter your phone number"
        editPhoneAlert.textFields![0].keyboardType = UIKeyboardType.numberPad
        
        editPhoneAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editPhoneAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let phoneText = editPhoneAlert.textFields![0].text
            self.myPhone.text = phoneText
        } ))
        
        self.present(editPhoneAlert, animated: true)
    }
    
    @IBAction func EditPassword(_ sender: UIButton) {
        let editPasswordAlert = UIAlertController(title: "Edit Password", message: "Enter Your Password", preferredStyle: .alert)
        
        editPasswordAlert.addTextField()
        editPasswordAlert.addTextField()
        editPasswordAlert.addTextField()
        
        
        editPasswordAlert.textFields![0].placeholder = "Enter your old password"
        editPasswordAlert.textFields![0].keyboardType = UIKeyboardType.default
        
        editPasswordAlert.textFields![1].placeholder = "Enter your new password"
        editPasswordAlert.textFields![1].keyboardType = UIKeyboardType.default
        
        editPasswordAlert.textFields![2].placeholder = "Re-enter your new password"
        editPasswordAlert.textFields![2].keyboardType = UIKeyboardType.default
        

        
        editPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editPasswordAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let passwordText = editPasswordAlert.textFields![0].text
            self.myPhone.text = "********"
        } ))
        
        self.present(editPasswordAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let pic = HomeScreenViewController.USER_OBJECT?.profilePicture, !pic.second.isEmpty{
            myImageLbl.isHidden = true
            myProfileImage.sd_setImage(with: URL(string: pic.second), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            print("no image")
            myImageLbl.layer.masksToBounds = true
            myImageLbl.text = HomeScreenViewController.USER_OBJECT?.name.first?.uppercased()
        }
        myName.text = HomeScreenViewController.USER_OBJECT?.name
        myEmail.text = HomeScreenViewController.USER_OBJECT?.email
        myPhone.text = HomeScreenViewController.USER_OBJECT?.phoneNumber
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
