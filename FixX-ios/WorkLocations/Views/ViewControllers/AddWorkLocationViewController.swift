//
//  AddWorkLocationViewController.swift
//  Locations
//
//  Created by Esraa Gohar on 6/18/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import DropDown

class AddWorkLocationViewController: UIViewController {

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
    
    @IBAction func cityActionBtn(_ sender: Any) {
        cityDropDown.show()
    }
    
    @IBAction func areaActionBtn(_ sender: Any) {
        areaDropDown.show()
    }
    
     @IBAction func addWorkLoactionActionBtn(_ sender: Any) {
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
