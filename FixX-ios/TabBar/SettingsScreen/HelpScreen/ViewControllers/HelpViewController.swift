//
//  HelpViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
   
    

    @IBOutlet weak var helpTableView: UITableView!
    @IBAction func backActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var helpLabels = ["About Us","Safety Tips","Terms And Conditions"]
    override func viewDidLoad() {
        super.viewDidLoad()
        helpTableView.delegate = self
        helpTableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpTableViewCell
        
        cell.helpTitleLabel.text = helpLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            let about = self.storyboard?.instantiateViewController(identifier: "AboutVC") as! AboutUsViewController
            self.present(about, animated: true, completion: nil)
        }
        if(indexPath.row == 1){
            let safety = self.storyboard?.instantiateViewController(identifier: "SafetyVC") as! SafetyTipsViewController
            self.present(safety, animated: true, completion: nil)
        }
        if(indexPath.row == 2){
            let terms = self.storyboard?.instantiateViewController(identifier: "TermsVC") as! TermsViewController
            self.present(terms, animated: true, completion: nil)
        }
        
    }
    

    

}
