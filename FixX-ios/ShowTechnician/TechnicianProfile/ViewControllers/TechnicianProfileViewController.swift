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
    
    
    var reviews = [Comment]()
    
    var tech : Technician?
    var onBookHandler : (()->())?
    var orderImagesUrls = [URL]()
    var job : Job?
    var displayOnly = true
    
    @IBOutlet weak var techImageView: UIImageView!
    @IBOutlet weak var techNameLabel: UILabel!
    @IBOutlet weak var techRatingView: CosmosView!
    @IBOutlet weak var techNoOfJobsLabel: UILabel!
    @IBOutlet weak var techNoOfReviews: UILabel!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var bookBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var techImageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tech?.name
        if(!displayOnly){
            bookBtn.isHidden = false
            bookBtnHeight.constant = 45
        }
        
        FirestoreService.shared.fetchCommentsForTech(techId: tech!.uid!) { [weak self](comments) in
            self?.reviews = comments
            self?.ReviewsTable.reloadData()
        } onFailHandler: {
            
        }

        if let image = tech?.profilePicture?.second, !image.isEmpty{
            techImageLbl.isHidden = true
            techImageView.isHidden = false
            techImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            techImageView.isHidden = true
            techImageLbl.isHidden = false
            techImageLbl.text = tech?.name.first?.uppercased()
        }
        
        techNameLabel.text = tech?.name ?? ""
        techRatingView.rating = tech?.rating ?? 2.5
        techNoOfJobsLabel.text = String(tech?.jobsCount ?? 0)
        techNoOfReviews.text = String(tech?.reviewCount ?? 0)
        
        techRatingView.settings.updateOnTouch = false
        techRatingView.settings.fillMode = .half
        techRatingView.settings.starMargin = 1
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookBtnPressed(_ sender: UIButton) {
        bookTechnician(with: tech!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.isEmpty{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewsTableViewCell
        
        cell.displayComment(reviews[indexPath.row])
        
        return cell
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
                self.onBookHandler?()
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
                            self?.onBookHandler?()
                            self?.navigationController?.popViewController(animated: true)
                            
                        } onFailHandler: {
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
}
