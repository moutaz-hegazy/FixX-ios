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
    
    @IBOutlet weak var techCancelBtn: UIButton!
    @IBOutlet weak var techAcceptBtn: UIButton!
    @IBOutlet weak var techRatingBtn: UIButton!
    @IBOutlet weak var techViewHeight: NSLayoutConstraint!
    @IBOutlet weak var biddersTableView: UITableView!
    
    
    private var jobImages = [StringPair]()
    private var bidders = [Technician]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func techChatBtnPressed(_ sender: UIButton) {
    }
    @IBAction func techCallBtnPressed(_ sender: UIButton) {
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
        
        if let imageCell = cell as? ImageCollectionViewCell{
            imageCell.attachedImage.sd_setImage(with: URL(string: jobImages[indexPath.row].second), placeholderImage: UIImage(named: "placeholder.png"))
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
                
        }
        return cell
    }
    
    
}
