import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var pagerContainer: UIView!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var controllers = [UIViewController]()
    private var logInVC : LogInViewController?
    private var signUpVC : SignUpViewControllerA?
    
    lazy var pagerVC : UIPageViewController = {
        UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewPager()
        pagerVC.delegate = self
        pagerVC.dataSource = self
        logInVC = UIStoryboard(name: "LogInViewController", bundle: nil).instantiateViewController(identifier: "logInVC")
            as? LogInViewController
        
        signUpVC = UIStoryboard(name: "SignUpViewControllerA", bundle: nil).instantiateViewController(identifier: "signUpAVC")
            as? SignUpViewControllerA
        
        
        controllers += [logInVC!,signUpVC!]
        pagerVC.setViewControllers([logInVC!], direction: .forward, animated: true){ [weak self] (_) in
            self?.logInBtn.backgroundColor = .blue
            self?.logInBtn.setTitleColor(.white, for: .normal)
            
            self?.signUpBtn.backgroundColor = .white
            self?.signUpBtn.setTitleColor(.blue, for: .normal)
        }
    }
    
    private func addViewPager(){
        addChild(pagerVC)
        pagerContainer.addSubview(pagerVC.view)
        pagerVC.didMove(toParent: self)
        setPagerConstraints()
    }
    
    private func setPagerConstraints(){
        pagerVC.view.translatesAutoresizingMaskIntoConstraints = false
        pagerVC.view.topAnchor.constraint(equalTo: pagerContainer.topAnchor, constant: 0.0).isActive = true
        pagerVC.view.bottomAnchor.constraint(equalTo: pagerContainer.bottomAnchor, constant: 0.0).isActive = true
        pagerVC.view.leadingAnchor.constraint(equalTo: pagerContainer.leadingAnchor, constant: 0.0).isActive = true
        pagerVC.view.trailingAnchor.constraint(equalTo: pagerContainer.trailingAnchor, constant: 0.0).isActive = true
    }
    
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        pagerVC.setViewControllers([logInVC!], direction: .reverse, animated: true){ [weak self] (_) in
            self?.logInBtn.backgroundColor = .blue
            self?.logInBtn.setTitleColor(.white, for: .normal)
            
            self?.signUpBtn.backgroundColor = .white
            self?.signUpBtn.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        pagerVC.setViewControllers([signUpVC!], direction: .forward, animated: true){ [weak self] (_) in
            self?.logInBtn.backgroundColor = .white
            self?.logInBtn.setTitleColor(.blue, for: .normal)
            
            self?.signUpBtn.backgroundColor = .blue
            self?.signUpBtn.setTitleColor(.white, for: .normal)
        }
    }
    @IBAction func googleBtnPressed(_ sender: Any) {
    }
}


extension RegistrationViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return controllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController),
              index < (controllers.count - 1) else {
            return nil
        }
        return controllers[index+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed){
            if(previousViewControllers.first is LogInViewController){
                logInBtn.backgroundColor = .white
                logInBtn.setTitleColor(.blue, for: .normal)
                
                signUpBtn.backgroundColor = .blue
                signUpBtn.setTitleColor(.white, for: .normal)
            }else{
                logInBtn.backgroundColor = .blue
                logInBtn.setTitleColor(.white, for: .normal)
                
                signUpBtn.backgroundColor = .white
                signUpBtn.setTitleColor(.blue, for: .normal)
            }
        }
    }
}
