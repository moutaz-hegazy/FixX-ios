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
    @IBOutlet weak var ratingViewBackground: UIView!
    @IBOutlet weak var ratingMiniView: UIView!
    
    @IBOutlet weak var techView: UIView!
    @IBOutlet weak var techCancelBtn: UIButton!
    @IBOutlet weak var techAcceptBtn: UIButton!
    @IBOutlet weak var techRatingBtn: UIButton!
    @IBOutlet weak var techViewHeight: NSLayoutConstraint!
    @IBOutlet weak var biddersTableView: UITableView!
    
    @IBOutlet weak var ratingCommentTxt: UITextField!
    @IBOutlet weak var ratingRatingbar: CosmosView!
    
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
        techRatingView.settings.fillMode = .half
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
        
        let chatVC = ChatWindowViewController()
        chatVC.person = tech
        present(chatVC, animated: true, completion: nil)
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
        ratingViewBackground.isHidden = false
        ratingMiniView.isHidden = false
        
        
    }
    @IBAction func submitRatingAction(_ sender: UIButton) {
        let comment = Comment(username: HomeScreenViewController.USER_OBJECT!.name, commentContent: ratingCommentTxt.text, profilePicture: HomeScreenViewController.USER_OBJECT!.profilePicture!.second, date: getCurrentdate(), reply: nil, timestamp: Int64(Date().timeIntervalSince1970) * 1000, rating: ratingRatingbar.rating)
        
        FirestoreService.shared.addRatingAndComment(techId: tech!.uid!, rating: getFinalRating(with: ratingRatingbar.rating), extraRating: getMonthlyRating(for: ratingRatingbar.rating), comment: comment, reviews: tech!.reviewCount + 1) {
            [weak self] in
            self?.techRatingView.rating = self?.getFinalRating(with: self?.ratingRatingbar.rating ?? 2.5) ?? 2.5
            self?.ratingViewBackground.isHidden = true
            self?.ratingMiniView.isHidden = true
            FirestoreService.shared.updateDocumentField(collectionName: "Jobs", fieldName: "rateable", element: false, documentId: self?.job?.jobId ?? "")
        } onFailHandler: {
            
        }

    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let yLocation = sender.location(in: ratingMiniView).y
        
        if(yLocation < 0 || yLocation > 250){
            ratingViewBackground.isHidden = true
            ratingMiniView.isHidden = true
        }
    }
    
    @IBAction func techViewTapAction(_ sender: UITapGestureRecognizer) {
        openTechProfile(for: tech)
    }
    
    private func openTechProfile(for tech : Technician?){
        if let techVC = UIStoryboard(name: "TechnicianProfileStoryboard", bundle: nil)
            .instantiateViewController(identifier: "techProfileScreenVC") as? TechnicianProfileViewController ,let technician = tech{
            techVC.tech = technician
            present(techVC, animated: true, completion: nil)
        }
    }
    
    private func getFinalRating(with rating : Double) -> Double{
        let reviews = tech!.reviewCount + 1
        let oldRating = tech!.rating ?? 2.5
        
        var oldValue = 2.5
        
        if(reviews > 1){
            oldValue = ((oldRating*Double(reviews))-4)/(Double(reviews) - 1)
        }
        return ((rating - oldValue)/Double(reviews))+oldValue
    }
    
    private func getMonthlyRating(for rating : Double) -> Double{
        let increase = (Double(job!.price!) * ((rating - 4)/5))/5
        return Double(tech?.monthlyRating ?? 0) + increase
    }
    
    private func getCurrentdate() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd-MMM-yyyy")
        var datetime = formatter.string(from: Date())
        datetime.remove(at: datetime.firstIndex(of: ".")!)
        let dateForm = datetime.replacingOccurrences(of: " ", with: "-")
        return dateForm
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
            self?.displayTechData(for: tech, with: jobType,and: price)

        }
    }
    
    private func displayTechData(for tech : Technician,with jobType : String,and price : String? = nil){
        self.biddersTableView.isHidden = true
        self.techView.isHidden = false
        self.techViewHeight.constant = 200
        
        if let image = tech.profilePicture?.second, !image.isEmpty{
            self.techImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            // tech image lbl.
            
        }
        
        self.techNameLbl.text = tech.name
        self.techRatingView.rating = tech.rating ?? 2.5
        
        if(jobType == "OnRequest"){
            self.techAcceptBtn.isHidden = false
            self.techCancelBtn.isHidden = false
            self.techPriceTitle.isHidden = false
            self.techPrice.isHidden = false
            self.techPrice.text = "\(price!) LE"
            
            self.techRatingBtn.isHidden = true
        }else if(jobType == "Accepted"){
            self.techAcceptBtn.isHidden = true
            self.techCancelBtn.isHidden = true
            self.techRatingBtn.isHidden = true
            self.techPriceTitle.isHidden = true
            self.techPrice.isHidden = true
            techViewHeight.constant = 100
        }else if(jobType == "Completed"){
            self.techAcceptBtn.isHidden = true
            self.techCancelBtn.isHidden = true
            self.techPriceTitle.isHidden = true
            self.techPrice.isHidden = true
            
            if let ratable = self.job?.rateable, ratable{
                self.techRatingBtn.isHidden = false
                techViewHeight.constant = 200
            }else{
                self.techRatingBtn.isHidden = true
                techViewHeight.constant = 100
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
            bidderCell.onAcceptHandler = {
                [weak self](price,tech) in
                self?.onTechAccepled(with: tech, and: price)
            }
            bidderCell.onChatHandler = {
                [weak self] tech in
                let chatVC = ChatWindowViewController()
                chatVC.person = tech
                self?.present(chatVC, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BidderTableViewCell
        {
            openTechProfile(for: cell.tech)
        }
    }
    
    private func onTechAccepled(with techData : Technician,and price : String){
        FirestoreService.shared.selectTechForJob(techId: techData.uid!, jobId: job!.jobId, price: price)
        displayTechData(for: techData, with: "Accepted")
        priceTitleLbl.isHidden = false
        priceLbl.text = price
        priceLbl.isHidden = false
    }
    
}
