import UIKit
import Toaster

class SignUpViewControllerD: UIViewController {
    
    var username: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func validateUsername()-> Bool{
           let usernameRegex = #"^[a-zA-Z]{6,15}$"#
           let validationResult = username?.range(
               of: usernameRegex,
               options: .regularExpression
           )
           return (validationResult != nil)
       }
       
       
    func validateEmail()-> Bool{
       let emailRegex = #"^\S+@\S+\.\S+$"#
       let validationResult = email?.range(
           of: emailRegex,
           options: .regularExpression
       )
       return (validationResult != nil)
    }


    func validatePassword()-> Bool{
       let passwordRegex = #"(?=.{6,15})"#
       let validationResult = password?.range(
           of: passwordRegex,
           options: .regularExpression
       )
       return (validationResult != nil)
    }
    
    func validateConfirmPassword()-> Bool{
        if (password != nil
                && confirmPassword != nil
                && password == confirmPassword){
            return true
        }else{
            return false
        }
    }
       
       
    func validateSignUp()-> Bool{
       if(validateUsername() &&
          validateEmail() &&
          validatePassword() &&
          validateConfirmPassword()){
           return true
       }else{
           return false
       }
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        if(validateSignUp()){
            print("signed up")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let customizeOrderViewController = storyBoard.instantiateViewController(withIdentifier: "covc")
            self.navigationController?.pushViewController(customizeOrderViewController, animated: true)
        }else{
            if(!validateUsername()){
                usernameTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
            if(!validateEmail()){
                emailTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
            if(!validatePassword()){
                passwordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
            if(!validateConfirmPassword()){
                confirmPasswordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
