//
//  HomeScreenViewController.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/5/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static var USER_OBJECT : Person?
//    static var USER_OBSERVER : ListenerRegistration?
    
    @IBOutlet weak var ServiceCollectionView : UICollectionView!
    @IBOutlet weak var workIcon: UIImageView!
    @IBOutlet weak var workBtn: UIButton!
    
    var arrServices = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ServiceCollectionView?.backgroundView = backgroungImage
        
        if let techAcc = HomeScreenViewController.USER_OBJECT as? Technician{
            workIcon.isHidden = false
            workBtn.isHidden = false
        }
        
        arrServices.append(Service(photo: UIImage(named: "Painter")!, name: "Painter"))
        arrServices.append(Service(photo: UIImage(named: "Plumber")!, name: "Plumber"))
        arrServices.append(Service(photo: UIImage(named: "Electrician")!, name: "Electrician"))
        arrServices.append(Service(photo: UIImage(named: "Carpenter")!, name: "Carpenter"))

        arrServices.append(Service(photo: UIImage(named: "Alumetal")!, name: "Alumetal"))

        arrServices.append(Service(photo: UIImage(named: "Air Conditioner")!, name: "Air Conditioner"))

        arrServices.append(Service(photo: UIImage(named: "Curtains")!, name: "Curtains"))

        arrServices.append(Service(photo: UIImage(named: "Glass")!, name: "Glass"))

        arrServices.append(Service(photo: UIImage(named: "Gypsum Works")!, name: "Gypsum Works"))

        arrServices.append(Service(photo: UIImage(named: "Marble")!, name: "Marble"))

        arrServices.append(Service(photo: UIImage(named: "Decoration Stones")!, name: "Decoration Stones"))

        arrServices.append(Service(photo: UIImage(named: "Parquet")!, name: "Parquet"))

        arrServices.append(Service(photo: UIImage(named: "Pest Control")!, name: "Pest Control"))

        arrServices.append(Service(photo: UIImage(named: "Satellite")!, name: "Satellite"))

        arrServices.append(Service(photo: UIImage(named: "Smith")!, name: "Smith"))

        arrServices.append(Service(photo: UIImage(named: "Pool maintain")!, name: "Pool maintain"))

        arrServices.append(Service(photo: UIImage(named: "tiles handyman")!, name: "tiles handyman"))

        arrServices.append(Service(photo: UIImage(named: "wood painter")!, name: "wood painter"))

        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func workBtnPressed(_ sender: Any) {
        if let myJobsVC = UIStoryboard(name: "MyJobs", bundle: nil).instantiateViewController(identifier: "myJobsVC") as? MyJobsViewController{
            
            present(myJobsVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ServiceCollectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCollectionViewCell
        let service = arrServices[indexPath.row]
        cell.setupCell(photo: service.photo, name: service.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.46, height: self.view.frame.height*0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.05
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left:0, bottom: 2, right: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("wezza >>> \(arrServices[indexPath.item].name)")
        startCustomizeOrderScreen(for : arrServices[indexPath.item].name)
    }
    
    private func startCustomizeOrderScreen(for jobtype : String){
        if let navVC = UIStoryboard(name: "CustomizeOrder", bundle: nil)
            .instantiateViewController(identifier: "navVC") as? UINavigationController{
            navVC.modalPresentationStyle = .fullScreen
            
            if let customizeVC = navVC.children.first as? CustomizeOrderViewController{
                customizeVC.jobType = jobtype
            }

            present(navVC, animated: true, completion: nil)
        }
    }

    
    let backgroungImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pattern1")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    struct Service {
        let photo : UIImage
        let name : String
    }
}
