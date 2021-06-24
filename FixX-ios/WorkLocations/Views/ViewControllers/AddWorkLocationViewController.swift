//
//  AddWorkLocationViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/18/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import iOSDropDown


class AddWorkLocationViewController: UIViewController {

    @IBOutlet weak var cityDropDown: DropDown!
    
    @IBOutlet weak var areaDropDown: DropDown!
    
    var onWorkAddressAddedHandler : ((String) -> ())?
    
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
    
  
    
     @IBAction func addWorkLoactionActionBtn(_ sender: Any) {
        if cityDropDown.text == "City"{
            self.showToast(message: "Please Choose City", font: .systemFont(ofSize: 12.0))
        }else if areaDropDown.text == "Area"{
            self.showToast(message: "Please Choose Area", font: .systemFont(ofSize: 12.0))
        }else{
            var address = "\(cityDropDown.text ?? ""),\(areaDropDown.text ?? "")"
            FirestoreService.shared.updateWorkLocations(loc: address, onSuccessHandler: {
                [weak self] in
                self?.onWorkAddressAddedHandler?(address)
                if ((HomeScreenViewController.USER_OBJECT as? Technician)?.workLocations != nil){
                    (HomeScreenViewController.USER_OBJECT as? Technician)?.workLocations! += [address]
                }else{
                    (HomeScreenViewController.USER_OBJECT as? Technician)?.workLocations = [address]
                }
                self?.dismiss(animated: true)
            }, onFailHandler: {})
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
    
    @IBAction func backActionBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
