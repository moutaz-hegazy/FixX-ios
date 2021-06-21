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
    let cities = ["Cairo", "Alexandria"]
    let alexArea = ["Sporting", "Smouha"]
    let cairoArea = ["Madenti", "Maadi"]
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
