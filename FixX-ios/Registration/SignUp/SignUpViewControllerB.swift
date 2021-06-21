import UIKit
import iOSDropDown

class SignUpViewControllerB: UIViewController {
    
    var jobProfile: String?
    var techData : Technician?
    
    @IBOutlet weak var jobProfileMenu: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        jobProfileMenu.optionArray = Constants.SERVICE_ARRAY
        jobProfileMenu.didSelect { [weak self](job, index, id) in
            self?.jobProfile = job
        }
    }
    
    @IBAction func next(_sender: UIButton){
        if(jobProfile != nil){
            techData?.jobTitle = jobProfile
            let storyBoard: UIStoryboard = UIStoryboard(name: "SignUpViewControllerC", bundle: nil)
            if let c = storyBoard.instantiateViewController(withIdentifier: "c") as? SignUpViewControllerC{
                c.techData = techData
                present(c, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func back(_sender: UIButton){
        presentingViewController?.dismiss(animated: true, completion: nil)
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
