import UIKit
import Toaster

class SignUpViewControllerA: UIViewController {
    
    var phoneNumber: String?
    var profileType: String?
    

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var technicianAvatar: UIImageView!
    @IBOutlet weak var userTag: UILabel!
    @IBOutlet weak var technicianTag: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user avatar...
        let tapUserAvatar = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.userTapped(gesture:)))
            userAvatar.isUserInteractionEnabled = true
            userAvatar.addGestureRecognizer(tapUserAvatar)
        
        //technician avatar...
        let tapTechnicianAvatar = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.technicianTapped(gesture:)))
        technicianAvatar.isUserInteractionEnabled = true
        technicianAvatar.addGestureRecognizer(tapTechnicianAvatar)
    }
    
    
    func validatePhoneNumber()-> Bool{
        let phoneRegex = #"(010|011|012|015)[0-9]{8}"#
        let validationResult = phoneNumber?.range(
              of: phoneRegex,
              options: .regularExpression
          )
        return (validationResult != nil)
    }
    
    
    @objc func userTapped(gesture: UITapGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            profileType = "User"
            technicianAvatar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            technicianTag.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userAvatar.layer.borderWidth = 1
            userAvatar.layer.masksToBounds = false
            userAvatar.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            userTag.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            userAvatar.layer.cornerRadius = userAvatar.frame.height/2
            userAvatar.clipsToBounds = true
            print(profileType)
        }
    }
    
    
    @objc func technicianTapped(gesture: UITapGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            profileType = "Technician"
            userAvatar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userTag.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            technicianTag.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            technicianAvatar.layer.borderWidth = 1
            technicianAvatar.layer.masksToBounds = false
            technicianAvatar.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            technicianAvatar.layer.cornerRadius = technicianAvatar.frame.height/2
            technicianAvatar.clipsToBounds = true
            print(profileType)
        }
    }
    
    
    func validateProfileType()-> Bool{
        if(profileType == "User" || profileType == "Technician"){
            return true
        }else{
            return false
        }
    }
       
       
    func validateSignUp1()-> Bool{
       if(validatePhoneNumber() &&
          validateProfileType()){
           return true
       }else{
           return false
       }
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        if(validateSignUp1()){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let b = storyBoard.instantiateViewController(withIdentifier: "b")
            self.navigationController?.pushViewController(b, animated: true)
        }else{
            if(!validatePhoneNumber()){
                phoneNumberTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
            if(!validateProfileType()){
                Toast(text:"Please, choose profile type", delay: Delay.short, duration: Delay.long).show()
            }
        }
    }
}