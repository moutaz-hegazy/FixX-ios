//
//  HomeScreenViewController.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/5/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ServiceCollectionView : UICollectionView!

    var arrServices = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ServiceCollectionView?.backgroundView = backgroungImage
        
        arrServices.append(Service(photo: UIImage(named: "painter")!, name: "Painter"))
        arrServices.append(Service(photo: UIImage(named: "plumber")!, name: "Plumber"))
        arrServices.append(Service(photo: UIImage(named: "electrician")!, name: "Electrician"))
        arrServices.append(Service(photo: UIImage(named: "carpenter")!, name: "Carpenter"))

        arrServices.append(Service(photo: UIImage(named: "alumetal")!, name: "Alumetal"))

        arrServices.append(Service(photo: UIImage(named: "airconditioner")!, name: "Air Conditioner"))

        arrServices.append(Service(photo: UIImage(named: "curtains")!, name: "Curtains"))

        arrServices.append(Service(photo: UIImage(named: "glass")!, name: "Glass"))

        arrServices.append(Service(photo: UIImage(named: "gypsumworks")!, name: "Gypsum Works"))

        arrServices.append(Service(photo: UIImage(named: "marbleandgranite")!, name: "Marble"))

        arrServices.append(Service(photo: UIImage(named: "masondecorationstones")!, name: "Decoration Stones"))

        arrServices.append(Service(photo: UIImage(named: "parquet")!, name: "Parquet"))

        arrServices.append(Service(photo: UIImage(named: "pestcontrol")!, name: "Pest Control"))

        arrServices.append(Service(photo: UIImage(named: "satellite")!, name: "Satellite"))

        arrServices.append(Service(photo: UIImage(named: "smith")!, name: "Smith"))

        arrServices.append(Service(photo: UIImage(named: "swimmingpool")!, name: "Pool maintain"))

        arrServices.append(Service(photo: UIImage(named: "tileshandyman")!, name: "tiles handyman"))

        arrServices.append(Service(photo: UIImage(named: "woodpainter")!, name: "wood painter"))

        
        
        // Do any additional setup after loading the view.
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
