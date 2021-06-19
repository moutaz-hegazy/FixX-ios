//
//  AddAddressViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/16/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import DropDown

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var notesTxt: UITextField!
    
    @IBOutlet weak var cityDropDownView: UIView!
    @IBOutlet weak var areaDropDownView: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    let cityDropDown = DropDown()
    let areaDropDown = DropDown()
    
    let cities = ["Cairo", "Alexandria"]
    let alexArea = ["Sporting", "Smouha"]
    let cairoArea = ["Madenti", "Maadi"]
    let emptyArea = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCityDropDown()
        setAreaDropDown()
        
    }
    
    @IBAction func cityDropDownActionBtn(_ sender: Any) {
        cityDropDown.show()
    }

    @IBAction func areaDropDownAction(_ sender: Any) {
        areaDropDown.show()
    }
    
    
    @IBAction func useMapActionBtn(_ sender: Any) {
        
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MVC") as! MapViewController
       // self.present(mapVC, animated: true, completion: nil)
       self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    @IBAction func addAddressActionBtn(_ sender: Any) {
        
        if cityLabel.text == "City" {
            self.showToast(message: "Please Choose City", font: .systemFont(ofSize: 12.0))
        }else if areaLabel.text == "Area"{
            self.showToast(message: "Please Choose Area", font: .systemFont(ofSize: 12.0))
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setCityDropDown(){
    cityLabel.text = "City"
    cityDropDown.anchorView = cityDropDownView
    cityDropDown.dataSource = cities
    cityDropDown.bottomOffset = CGPoint(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
    cityDropDown.topOffset = CGPoint(x: 0, y: -(cityDropDown.anchorView?.plainView.bounds.height)!)
    cityDropDown.direction = .bottom
    cityDropDown.selectionAction = { [self] (index: Int, item: String) in
        cityLabel.text = item
        print("selected item is \(item) at index \(index)")
        setAreaDropDown()
        }
    }
    
    func setAreaDropDown(){
    areaLabel.text = "Area"
    areaDropDown.anchorView = areaDropDownView
        if cityLabel.text == "Cairo" {
            areaDropDown.dataSource = cairoArea
        }else if cityLabel.text == "Alexandria" {
            areaDropDown.dataSource = alexArea
        } else {
            areaDropDown.dataSource = emptyArea
        }
  
    areaDropDown.bottomOffset = CGPoint(x: 0, y: (areaDropDown.anchorView?.plainView.bounds.height)!)
    areaDropDown.topOffset = CGPoint(x: 0, y: -(areaDropDown.anchorView?.plainView.bounds.height)!)
    areaDropDown.direction = .bottom
    areaDropDown.selectionAction = { [self] (index: Int, item: String) in
        areaLabel.text = item
        print("selected item is \(item) at index \(index)")
        }
    }
    

}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }

