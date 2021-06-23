//
//  AddAddressViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/16/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import iOSDropDown

class AddAddressViewController: UIViewController, AddressProtocol {

    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var notesTxt: UITextField!

    
    @IBOutlet weak var cityDropDown: DropDown!
    
    @IBOutlet weak var areaDropDown: DropDown!
    
    var cityFound = false
    var areaFound = false
    
    var onAddressAddedHandler : ((String) -> ())?

    
    let cities = ["Cairo", "Alexandria"]
    let alexArea = ["AR Riyadah",
                    "Moharam Bek",
                    "Abu Qir",
                    "Al Montaza",
                    "Al Hadarah",
                    "Al Ibrahimeyah",
                    "Asafra",
                    "Al Azaritah",
                    "Bahari",
                    "Dekhela",
                    "Bokli",
                    "Borg Al Arab",
                    "Al Qabari",
                    "Fleming",
                    "Janklees",
                    "Gleem",
                    "Kafr Abdou",
                    "Louran",
                    "El Mandara",
                    "Miami",
                    "San Stifano",
                    "Sidy Beshr",
                    "Smouha",
                    "Sidy Gaber",
                    "Shatebi",
                    "Sporting",
                    "Victoria",
                    "Stanli",
                    "Wabor El Maya",
                    "El Hanovil",
                    "El Bitash",
                    "Qism Bab Sharqi",
                    //"Qism El-Raml",
                    "Mansheya",
                    "Al Attarin",
                    "First Al Raml",
                    "Mustafa Kamel",
                    "Ezbet Saad",
                    "Abees"]
    let cairoArea = ["Al-Shrouk",
                     "1st Settlement",
                     "Fifth Settlement",
                     "Madenti",
                     "Al-Rehab",
                     "10th Of Ramadan",
                     "Badr City",
                     "Zamalek",
                     "Heliopolis",
                     "Nasser City",
                     "Qobbah",
                     "Maadi",
                     "Mokkatm",
                     "Mohandsen",
                     "Shekh Zayed",
                     "Dokki",
                     "Giza Square",
                     "Haram",
                     "Fissal",
                     "Shobra",
                     "Obour",
                     "Matareya",
                     "6th October",
                     "Helwan",
                     "Ain Shams",
                     "Manyal",
                     "Agouza"]
    let emptyArea = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCityDropDown()
        setAreaDropDown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        areaFound = false
        cityFound = false
    }
    
    @IBAction func useMapActionBtn(_ sender: Any) {
        
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MVC") as! MapViewController
        mapVC.delegete = self
       self.present(mapVC, animated: true, completion: nil)
    }
    
    
    @IBAction func addAddressActionBtn(_ sender: Any) {
    
        if cityDropDown.text == "City"{
            self.showToast(message: "Please Choose City", font: .systemFont(ofSize: 12.0))
        }else if areaDropDown.text == "Area"{
            self.showToast(message: "Please Choose Area", font: .systemFont(ofSize: 12.0))
        }else{
            var address = "\(titleTxt.text ?? "")%\(cityDropDown.text ?? ""),\(areaDropDown.text ?? "")/"
            if let street = streetTxt.text, !street.isEmpty{
                address += "street: \(street)"
            }
            if let building = buildingTxt.text, !building.isEmpty{
                address += ",building: \(building)"
            }
            if let floor = floorTxt.text, !floor.isEmpty{
                address += ",floor: \(floor)"
            }
            if let notes = notesTxt.text, !notes.isEmpty{
                address += ",\(notes)"
            }
            
            FirestoreService.shared.updateUserLocations(loc: address) {
                [weak self] in
                self?.onAddressAddedHandler?(address)
                if (HomeScreenViewController.USER_OBJECT?.locations != nil){
                    HomeScreenViewController.USER_OBJECT?.locations! += [address]
                }else{
                    HomeScreenViewController.USER_OBJECT?.locations = [address]
                }
                self?.navigationController?.popViewController(animated: true)
            } onFailHandler: {
            }
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
    
       
    }
    
    func sendAddressBack(city: String, area: String, subArea: String) {
        
        print(city)
        print(area)
        print(subArea)
        
        for item in cities.indices{
            
            if cities[item].contains(city){
                cityDropDown.text = cities[item]
                cityFound = true
                
                if cityDropDown.text == "Cairo" {
                    areaDropDown.optionArray = cairoArea
                }else if cityDropDown.text == "Alexandria" {
                    areaDropDown.optionArray = alexArea
                } else {
                    areaDropDown.optionArray = emptyArea
                }
            }
        }
        if !cityFound{
            cityDropDown.text = "City"
        }
        
        if cityDropDown.text == "Cairo"{
            for item in cairoArea.indices{
                if cairoArea[item].contains(area) || cairoArea[item].contains(subArea){
                    areaDropDown.text = cairoArea[item]
                    areaFound = true
                }
            }
        }else if cityDropDown.text == "Alexandria"{
            for item in alexArea.indices{
                if alexArea[item].contains(area) || alexArea[item].contains(subArea){
                    areaDropDown.text = alexArea[item]
                    areaFound = true
                }
            }
        }
        
        if !areaFound{
            areaDropDown.text = "Area"
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

