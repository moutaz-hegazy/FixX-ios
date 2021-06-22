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
    
    
    func validatePassword()-> Bool{
        let validationResult = password?.range(
        of: passwordRegex,
        options: .regularExpression
        )
        return (validationResult != nil)
    }
    
    
    func validateLogin()-> Bool{
        if(validateEmail() && validatePassword()){
            return true
        }else{
            if(!validateEmail()){
                emailTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
                Toast(text: "Invalid Email. Enter a proper Email.").show()
            }else if(!validatePassword()){
                passwordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
                Toast(text: "Invalid Password. Enter a proper Password.").show()
            }
            return false
        }
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        email = emailTextField.text
        password = passwordTextField.text
        if(validateLogin()){
            FirestoreService.shared.loginWithEmailAndPassword(email: email!, password: password!) {
                [weak self] (person) in
                HomeScreenViewController.USER_OBJECT = person
                self?.startHomeScreen()
            } onFailHandler: {
                
            }
        }
    }
        
    private func startHomeScreen(){
        if let homeVC = UIStoryboard(name: "TabBarStoryboard", bundle: nil).instantiateViewController(identifier: "tabBarVC") as? UITabBarController{
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        print("Google")
    }
}


extension UIButton{
    
    @IBInspectable
    var addBorder : CGFloat{
        get{
            return self.layer.borderWidth
        }
        set(newValue){
            self.layer.borderWidth = newValue
        }
    }
    
}
