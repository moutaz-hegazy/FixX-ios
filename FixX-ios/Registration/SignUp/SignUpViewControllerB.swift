import UIKit
import iOSDropDown

class SignUpViewControllerB: UIViewController {
    
    var jobProfile: String?
    
    @IBOutlet weak var jobProfileMenu: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        jobProfileMenu.optionArray = ["Plumber", "Electrician", "Carpenter", "Painter"]
        jobProfileMenu.optionIds = [1,2,3,4]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next(_sender: UIButton){
        print("next")
        //jobProfile = jobProfileMenu
        if(jobProfile != nil){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let c = storyBoard.instantiateViewController(withIdentifier: "c")
            self.navigationController?.pushViewController(c, animated: true)
        }
    }
    
    @IBAction func back(_sender: UIButton){
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
