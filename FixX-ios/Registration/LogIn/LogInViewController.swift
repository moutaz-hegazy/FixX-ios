import UIKit
import Toaster

class LogInViewController: UIViewController {
        
    var email: String?
    var password: String?
    
    
    let emailRegex = #"^\S+@\S+\.\S+$"#
    let passwordRegex = #"(?=.{6,15})"#
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let tapForgotPassword = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.tapForgotPassword(gesture:)))
               forgotPassword.isUserInteractionEnabled = true
               forgotPassword.addGestureRecognizer(tapForgotPassword)
        
        
        emailTextField.addTarget(self, action: #selector(LogInViewController.checkEmailError(emailTextField:)), for: .editingChanged)
        emailTextField.isUserInteractionEnabled = true
        
        
        passwordTextField.addTarget(self, action: #selector(LogInViewController.checkPasswordError(passwordTextField:)), for: .editingChanged)
        passwordTextField.isUserInteractionEnabled = true
    }
    
    
    
    @objc func tapForgotPassword(gesture: UITapGestureRecognizer){
        if (gesture.view as? UILabel) != nil{
            print("Sheesh. Forgot it.")
        }
    }
    
    
    func validateEmail()-> Bool{
        let validationResult = email?.range(
        of: emailRegex,
        options: .regularExpression
        )
        return (validationResult != nil)
    }
    
    @objc func checkEmailError(emailTextField: UITextField){
        email = emailTextField.text
        if(!validateEmail()){
            emailTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
        }
    }
    
    
    func validatePassword()-> Bool{
        let validationResult = password?.range(
        of: passwordRegex,
        options: .regularExpression
        )
        return (validationResult != nil)
    }
    
    @objc func checkPasswordError(passwordTextField: UITextField){
        password = passwordTextField.text
        if(!validatePassword()){
           passwordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
        }
    }
    
    
    func validateLogin()-> Bool{
        if(validateEmail() && validatePassword()){
            return true
        }else{
            if(!validateEmail()){
                emailTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
                Toast(text: "Invalid Email. Enter a proper Email.").show()            }
            if(!validatePassword()){
                passwordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
                Toast(text: "Invalid Password. Enter a proper Password.").show()
            }
            return false
        }
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        print("Login")
        if(validateLogin()){
            let storyBoard: UIStoryboard = UIStoryboard(name: "CustomizeOrder", bundle: nil)
            let customizeOrderViewController = storyBoard.instantiateViewController(withIdentifier: "covc")
            self.navigationController?.pushViewController(customizeOrderViewController, animated: true)
        }
    }
        
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        print("Google")
    }
}
