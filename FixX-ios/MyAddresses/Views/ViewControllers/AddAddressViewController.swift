//
//  AddAddressViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/16/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import iOSDropDown

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var notesTxt: UITextField!

    
    @IBOutlet weak var cityDropDown: DropDown!
    
    @IBOutlet weak var areaDropDown: DropDown!
    

    
    let cities = ["Cairo", "Alexandria"]
    let alexArea = ["Sporting", "Smouha"]
    let cairoArea = ["Madenti", "Maadi"]
    let emptyArea = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCityDropDown()
        setAreaDropDown()
        
    }
    
    @IBAction func useMapActionBtn(_ sender: Any) {
        
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MVC") as! MapViewController
       self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    @IBAction func addAddressActionBtn(_ sender: Any) {
    
        if cityDropDown.text == "City"{
            self.showToast(message: "Please Choose City", font: .systemFont(ofSize: 12.0))
        }else if areaDropDown.text == "Area"{
            self.showToast(message: "Please Choose Area", font: .systemFont(ofSize: 12.0))
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setCityDropDown(){
        cityDropDown.text = "City"
        cityDropDown.isSearchEnable = false
        cityDropDown.optionArray = cities
        cityDropDown.didSelect{ [self](selectedText , index ,id) in
            if selectedText == "Cairo" {
                areaDropDown.optionArray = cairoArea
            }else if selectedText == "Alexandria" {
                areaDropDown.optionArray = alexArea
            } else {
                areaDropDown.optionArray = emptyArea
            }
    }
}
    
    func setAreaDropDown(){
        areaDropDown.text = "Area"
        areaDropDown.isSearchEnable = false
    
        if cityDropDown.text == "Cairo" {
            areaDropDown.optionArray = cairoArea
        }else if cityDropDown.text == "Alexandria" {
            areaDropDown.optionArray = alexArea
        } else {
            areaDropDown.optionArray = emptyArea
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

