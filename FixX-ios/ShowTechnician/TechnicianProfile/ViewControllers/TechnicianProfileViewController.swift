//
//  TechnicianProfileViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/21/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class TechnicianProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var ReviewsTable: UITableView!
    
    
    var reviews = [Review]()
    
    var name : String?
    var image : String?
    var rating : Double?
    var noOfJobs : String?
    var noOfReviews : String?
        
    @IBOutlet weak var techImageView: UIImageView!
    
    @IBOutlet weak var techNameLabel: UILabel!
    
    
    @IBOutlet weak var techRatingView: CosmosView!
    
    
    @IBOutlet weak var techNoOfJobsLabel: UILabel!
    
    @IBOutlet weak var techNoOfReviews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        techNameLabel.text = name ?? ""
        techRatingView.rating = rating ?? 5
        techNoOfJobsLabel.text = noOfJobs ?? "0"
        techNoOfReviews.text = noOfReviews ?? "0"
        
        techRatingView.settings.updateOnTouch = false
        techRatingView.settings.fillMode = .precise
        techRatingView.settings.starMargin = 1
       reviews = [Review(reviewPhoto: UIImage(imageLiteralResourceName: "profile"), reviewName: "Dina Adel", reviewRate: 3.5, reviewDate: "4-06-21", comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),Review(reviewPhoto: UIImage(imageLiteralResourceName: "profile"), reviewName: "Esraa Gohar", reviewRate: 3, reviewDate: "3-06-21", comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")]

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewsTableViewCell
        
        let review = reviews[indexPath.row]
        cell.reviewRate.rating = review.reviewRate
        cell.reviewRate.settings.updateOnTouch = false
        cell.reviewRate.settings.fillMode = .precise
        cell.reviewRate.settings.starMargin = 1
        cell.reviewName?.text = review.reviewName
        cell.reviewDate?.text = review.reviewDate
        cell.reviewComment?.text = review.comment
        cell.reviewImage?.image = review.reviewPhoto
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    struct Review {
        let reviewPhoto : UIImage
        let reviewName : String
        let reviewRate : Double
        let reviewDate : String
        let comment : String
    }
    

}
