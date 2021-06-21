import UIKit
import iOSDropDown

class SignUpViewControllerC: UIViewController {
    
    @IBOutlet weak var cityMenu: DropDown!
    @IBOutlet weak var areaMenu: DropDown!
    @IBOutlet weak var locationsTableView: UITableView!
    
    private var selectedCity : String?
    private var selectedArea : String?
    var techData : Technician?
    
    private var areas = [String]()
    
    private var workLocations = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityMenu.optionArray = ["Alexandria", "Cairo"]
        
        areaMenu.optionArray = areas
        areaMenu.didSelect { [weak self](area, index, id) in
            self?.selectedArea = area
        }
        
        cityMenu.didSelect { [unowned self](city, index, id) in
            self.selectedCity = city
            if city == "Cairo"{
                self.areas = ["madenti", "maadi", "al-shrouk"]
                self.areaMenu.optionArray = self.areas
            }else if city == "Alexandria"{
                self.areas = ["montaza", "asafra", "mandara"]
                self.areaMenu.optionArray = self.areas
            }else{
                self.areas = []
                self.areaMenu.optionArray = self.areas
            }
        }
    }
    
    @IBAction func addAddress(_sender: UIButton){
        if(selectedCity != nil && selectedArea != nil){
            let newAdd = "\(selectedCity!),\(selectedArea!)"
            if(!workLocations.contains(newAdd)){
                workLocations.append(newAdd)
                locationsTableView.reloadData()
            }
            cityMenu.text = ""
            areaMenu.text = ""
            selectedCity = nil
            selectedArea = nil
        }
    }
    
    @IBAction func next(_sender: UIButton){
        if(!workLocations.isEmpty){
            techData?.workLocations = workLocations
            let storyBoard: UIStoryboard = UIStoryboard(name: "SignUpViewControllerD", bundle: nil)
            if let signUpViewControllerD = storyBoard.instantiateViewController(withIdentifier: "d")
                as? SignUpViewControllerD{
                signUpViewControllerD.regData = techData
                present(signUpViewControllerD, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func back(_sender: UIButton){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}


extension SignUpViewControllerC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workLocationCell", for: indexPath)
        
        cell.textLabel?.text = workLocations[indexPath.row]
        
        return cell
    }
    
    
    
    
}
