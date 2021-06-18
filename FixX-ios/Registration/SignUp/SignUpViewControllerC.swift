import UIKit
import iOSDropDown

class SignUpViewControllerC: UIViewController {
    
    var city: String?
    
    @IBOutlet weak var cityMenu: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityMenu.optionArray = ["Alexandria", "Cairo", "Suez", "Luxor", "Aswan"]
        cityMenu.optionIds = [1,2,3,4,5]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAddress(_sender: UIButton){
        print("addAddress")
    }
    
    @IBAction func next(_sender: UIButton){
        print("next")
        if(city != nil){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let SignUpViewControllerD = storyBoard.instantiateViewController(withIdentifier: "d")
            self.navigationController?.pushViewController(SignUpViewControllerD, animated: true)
        }
    }
    
    @IBAction func back(_sender: UIButton){
        print("back")
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
