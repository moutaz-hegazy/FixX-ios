
import UIKit
import Toaster

class SignUpViewControllerD: UIViewController {
    
    var username: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var regData : Person?
    
    
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
    
    private func startHomeScreen(){
        if let homeVC = UIStoryboard(name: "TabBarStoryboard", bundle: nil).instantiateViewController(identifier: "tabBarVC") as? UITabBarController{
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        username = usernameTextField.text
        email = emailTextField.text
        password = passwordTextField.text
        confirmPassword = confirmPasswordTextField.text
        if(validateSignUp()){
            regData?.name = username!
            regData?.email = email!
            FirestoreService.shared.registerUser(user: regData!, password: password!) {
                [weak self] (person) in
                
                HomeScreenViewController.USER_OBJECT = person
                self?.startHomeScreen()
            } onFailHandler: {
                
            }


            
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
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
