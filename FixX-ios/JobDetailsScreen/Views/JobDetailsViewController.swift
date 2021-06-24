//
//  JobDetailsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class JobDetailsViewController: UIViewController {
    
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var fromTimeLbl: UILabel!
    @IBOutlet weak var toTimeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imagesTitleLbl: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesHeight: NSLayoutConstraint!
    @IBOutlet weak var techImageView: UIImageView!
    @IBOutlet weak var techNameLbl: UILabel!
    @IBOutlet weak var techRatingView: CosmosView!
    @IBOutlet weak var techPriceTitle: UILabel!
    @IBOutlet weak var techPrice: UILabel!
    
    @IBOutlet weak var techView: UIView!
    @IBOutlet weak var techCancelBtn: UIButton!
    @IBOutlet weak var techAcceptBtn: UIButton!
    @IBOutlet weak var techRatingBtn: UIButton!
    @IBOutlet weak var techViewHeight: NSLayoutConstraint!
    @IBOutlet weak var biddersTableView: UITableView!
    
    
    private var jobImages = [StringPair]()
    private var bidders = [Technician]()
    var onLeaveHandler : (()->())?
    
    var job: Job?
    var tech : Technician?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let jobData = job else {
            return
        }
        techRatingView.settings.updateOnTouch = false
        displayJobData(for: jobData)
        if let techId = jobData.techID{
            displaySingleTech(techId: techId, jobType: jobData.status)
        }else if jobData.privateRequest, let tech = jobData.bidders?.first{
            displaySingleTech(techId: tech.key, jobType: jobData.status,price: tech.value)
        }else{
            techView.isHidden = true
            techViewHeight.constant = 0
            biddersTableView.isHidden = false
            if let bidders = jobData.bidders{
                bidders.forEach { (bidder) in
                    FirestoreService.shared.fetchUserOnce(uid: bidder.key) {
                        [weak self](person) in
                        if let tech = person as? Technician{
                            self?.bidders += [tech]
                            self?.biddersTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onLeaveHandler?()
    }
    
    @IBAction func techChatBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func techCallBtnPressed(_ sender: UIButton) {
        if let url = URL(string: "tel://\(tech!.phoneNumber)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    @IBAction func techCancelBtnPressed(_ sender: UIButton) {
        FirestoreService.shared.removeBidders(jobId: job!.jobId)
        techViewHeight.constant = 0
        techView.isHidden = true
    }
    @IBAction func techAcceptBtnPressed(_ sender: UIButton) {
        let price = job!.bidders![tech!.uid!]!
        FirestoreService.shared.selectTechForJob(techId: tech!.uid!, jobId: job!.jobId, price: price)
        techAcceptBtn.isHidden = true
        techCancelBtn.isHidden = true
        techPrice.isHidden = true
        techPriceTitle.isHidden = true
        priceLbl.isHidden = false
        priceLbl.text = "\(price) LE"
        priceTitleLbl.isHidden = false
    }
    @IBAction func techRatingBtnPressed(_ sender: UIButton) {
        if let ratingVC = storyboard?.instantiateViewController(identifier: "ratingVC") as? RatingViewController{
//            ratingVC.modalPresentationStyle = .popover
            present(ratingVC, animated: true, completion: nil)
        }
        
    }
    
    
    private func getLocation(from locString:String)->String{
        let subString = String(locString[..<locString.firstIndex(of: "%")!])
        if(subString.isEmpty){
            let loc = String(locString[locString.index(after: locString.firstIndex(of: "%")!)...])
            return loc
        }else{
            return subString
        }
    }
    
    private func displayJobData(for job:Job ){
        jobImageView.image = UIImage(named: job.type)
        addressLbl.text = getLocation(from: job.location!)
        fromTimeLbl.text = job.fromTime
        toTimeLbl.text = job.toTime
        if(job.status == "Completed"){
            dateLbl.text = job.completionDate
        }else{
            dateLbl.text = job.date
        }
        if let jobPrice = job.price{
            priceLbl.text = "\(jobPrice) LE"
            priceLbl.isHidden = false
            priceTitleLbl.isHidden = false
        }else{
            priceLbl.isHidden = true
            priceTitleLbl.isHidden = true
        }
        
        if(job.status == "OnRequest"){
            statusLbl.text = "On Request"
        }else{
            statusLbl.text = job.status
        }
        
        //MARK: - could be changed with extensions.
        if(job.description.isEmpty){
            descTitleLbl.text = ""
            descTitleLbl.isHidden = true
            descriptionLbl.isHidden = true
            descriptionLbl.text = ""
        }else{
            descTitleLbl.isHidden = false
            descTitleLbl.text = "Description"
            descriptionLbl.isHidden = false
            descriptionLbl.text = job.description
        }
        
        if let images = job.images,!images.isEmpty{
            jobImages = images
            imagesTitleLbl.text = "Images"
            imagesTitleLbl.isHidden = false
            imagesCollectionView.isHidden = false
            imagesHeight.constant = 150
            imagesCollectionView.reloadData()
        }else{
            imagesTitleLbl.text = ""
            imagesTitleLbl.isHidden = true
            imagesCollectionView.isHidden = true
            imagesHeight.constant = 0
        }
    }
    
    private func displaySingleTech(techId : String, jobType : String, price : String? = nil){
        FirestoreService.shared.fetchUserOnce(uid: techId) {
            [weak self] (person) in
            guard let tech = person as? Technician else{
                return
            }
            self?.tech = tech
            self?.biddersTableView.isHidden = true
            self?.techView.isHidden = false
            self?.techViewHeight.constant = 200
            
            if let image = tech.profilePicture?.second, !image.isEmpty{
                self?.techImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
            }else{
                // tech image lbl.
                
            }
            
            self?.techNameLbl.text = tech.name
            self?.techRatingView.rating = tech.rating ?? 2.5
            
            if(jobType == "OnRequest"){
                self?.techAcceptBtn.isHidden = false
                self?.techCancelBtn.isHidden = false
                self?.techPriceTitle.isHidden = false
                self?.techPrice.isHidden = false
                self?.techPrice.text = "\(price!) LE"
                
                self?.techRatingBtn.isHidden = true
            }else if(jobType == "Accepted"){
                self?.techAcceptBtn.isHidden = true
                self?.techCancelBtn.isHidden = true
                self?.techRatingBtn.isHidden = true
                self?.techPriceTitle.isHidden = true
                self?.techPrice.isHidden = true
            }else if(jobType == "Completed"){
                self?.techAcceptBtn.isHidden = true
                self?.techCancelBtn.isHidden = true
                self?.techPriceTitle.isHidden = true
                self?.techPrice.isHidden = true
                
                if let ratable = self?.job?.rateable, ratable{
                    self?.techRatingBtn.isHidden = false
                }else{
                    self?.techRatingBtn.isHidden = true

                }
            }
        }
    }
}

extension JobDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        if let imageCell = cell as? jobDetailsImageCollectionViewCell{
            imageCell.imageView.sd_setImage(with: URL(string: jobImages[indexPath.row].second), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        return cell
    }
}

extension JobDetailsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bidders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bidderCell", for: indexPath)
        if let bidderCell = cell as? BidderTableViewCell{
            bidderCell.displayBidderData(for: bidders[indexPath.row], with: job?.bidders?[bidders[indexPath.row].uid!] ?? "none")
        }
        return cell
    }
    
    
}
