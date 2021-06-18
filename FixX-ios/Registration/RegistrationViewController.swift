//import UIKit
//
//class RegistrationViewController: UIViewController {
//
//    
//    var loginView: UIView?
//    var signupView: UIView?
//    
//    @IBOutlet weak var viewContainer: UIView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loginView = LoginViewController().view
//        signupView = SignUpViewController().view
//        loginView?.center = CGPoint(x: (viewContainer?.frame.size.width ?? 150)/2, y: (viewContainer?.frame.size.height ?? 150)/2)
//        signupView?.center = CGPoint(x: (viewContainer?.frame.size.width ?? 150)/2, y: (viewContainer?.frame.size.height ?? 150)/2)
//        viewContainer.backgroundColor = UIColor.clear
//        viewContainer.addSubview(loginView!)
//        viewContainer.addSubview(signupView!)
//        signupView?.isHidden = true
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewContainer.alpha = 0
//        viewContainer.transform = CGAffineTransform(translationX: 0, y: -200)
//        viewContainer.transform = CGAffineTransform(scaleX: 0, y: 0)
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 2.0, delay: 1.0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseOut], animations: {
//            self.viewContainer.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.viewContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.viewContainer.alpha = 1
//        }, completion: nil)
//    }
//    
//    
//    @IBAction func shuffle(_ sender: UISegmentedControl) {
//        loginView?.isHidden = false
//        signupView?.isHidden = false
//        switch sender.selectedSegmentIndex{
//            case 0: viewContainer.bringSubviewToFront(loginView!)
//                break
//            case 1: viewContainer.bringSubviewToFront(signupView!)
//                break
//            default: viewContainer.bringSubviewToFront(loginView!)
//                break
//        }
//    }
//}
