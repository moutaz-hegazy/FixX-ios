//
//  MyJobsViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/22/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class MyJobsViewController: UIViewController, UIPageViewControllerDelegate,
                            UIPageViewControllerDataSource{
    
    @IBOutlet weak var pagerContainerView: UIView!
    @IBOutlet weak var ongoingBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var availableBtn: UIButton!
    
    private var controllers = [UIViewController]()
    private var ongoingVC : OngoingJobsViewController?
    private var completedVC : CompletedJobsViewController?
    private var availableVC : AvailableJobsViewController?
    
    lazy var pagerVC : UIPageViewController = {
        UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewPager()
        pagerVC.delegate = self
        pagerVC.dataSource = self
        ongoingVC = storyboard?
            .instantiateViewController(identifier: "ongoingVC")
        completedVC = storyboard?.instantiateViewController(identifier: "completedVC")
        
        availableVC = storyboard?.instantiateViewController(identifier: "availableVC")
        
        controllers += [ongoingVC!,completedVC!,availableVC!]
        pagerVC.setViewControllers([ongoingVC!], direction: .forward, animated: true){ [weak self] (_) in
            self?.ongoingBtn.backgroundColor = .blue
            self?.ongoingBtn.setTitleColor(.white, for: .normal)

            self?.completedBtn.backgroundColor = .white
            self?.completedBtn.setTitleColor(.blue, for: .normal)
            
            self?.availableBtn.backgroundColor = .white
            self?.availableBtn.setTitleColor(.blue, for: .normal)
        }
    }
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func ongoingPressed(_ sender: UIButton) {
        self.ongoingBtn.backgroundColor = .blue
        self.ongoingBtn.setTitleColor(.white, for: .normal)
        
        self.completedBtn.backgroundColor = .white
        self.completedBtn.setTitleColor(.blue, for: .normal)
        
        self.availableBtn.backgroundColor = .white
        self.availableBtn.setTitleColor(.blue, for: .normal)
        pagerVC.setViewControllers([ongoingVC!], direction: .reverse, animated: true)
    }
    
    @IBAction func completedPressed(_ sender: UIButton) {
        self.ongoingBtn.backgroundColor = .white
        self.ongoingBtn.setTitleColor(.blue, for: .normal)

        self.completedBtn.backgroundColor = .blue
        self.completedBtn.setTitleColor(.white, for: .normal)

        self.availableBtn.backgroundColor = .white
        self.availableBtn.setTitleColor(.blue, for: .normal)
        if (pagerVC.viewControllers?.first is OngoingJobsViewController){
            pagerVC.setViewControllers([completedVC!], direction: .forward, animated: true)
        }else if (pagerVC.viewControllers?.first is AvailableJobsViewController){
            pagerVC.setViewControllers([completedVC!], direction: .reverse, animated: true)
        }else{}
    }
    
    @IBAction func availablePressed(_ sender: Any) {
        self.ongoingBtn.backgroundColor = .white
        self.ongoingBtn.setTitleColor(.blue, for: .normal)
        
        self.completedBtn.backgroundColor = .white
        self.completedBtn.setTitleColor(.blue, for: .normal)
        
        self.availableBtn.backgroundColor = .blue
        self.availableBtn.setTitleColor(.white, for: .normal)
        pagerVC.setViewControllers([availableVC!], direction: .forward, animated: true)
    }
    
    

    private func addViewPager(){
        addChild(pagerVC)
        pagerContainerView.addSubview(pagerVC.view)
        pagerVC.didMove(toParent: self)
        setPagerConstraints()
    }
    
    private func setPagerConstraints(){
        pagerVC.view.translatesAutoresizingMaskIntoConstraints = false
        pagerVC.view.topAnchor.constraint(equalTo: pagerContainerView.topAnchor, constant: 5.0).isActive = true
        pagerVC.view.bottomAnchor.constraint(equalTo: pagerContainerView.bottomAnchor, constant: 0.0).isActive = true
        pagerVC.view.leadingAnchor.constraint(equalTo: pagerContainerView.leadingAnchor, constant: 0.0).isActive = true
        pagerVC.view.trailingAnchor.constraint(equalTo: pagerContainerView.trailingAnchor, constant: 0.0).isActive = true
    }
    
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
            if(previousViewControllers.first is OngoingJobsViewController){
                ongoingBtn.backgroundColor = .white
                ongoingBtn.setTitleColor(.blue, for: .normal)
                
                completedBtn.backgroundColor = .blue
                completedBtn.setTitleColor(.white, for: .normal)
            }else if (previousViewControllers.first is AvailableJobsViewController){
                availableBtn.backgroundColor = .white
                availableBtn.setTitleColor(.blue, for: .normal)
                
                completedBtn.backgroundColor = .blue
                completedBtn.setTitleColor(.white, for: .normal)
            }else{
                if (pagerVC.viewControllers?.first is OngoingJobsViewController){
                    ongoingBtn.backgroundColor = .blue
                    ongoingBtn.setTitleColor(.white, for: .normal)
                    
                    completedBtn.backgroundColor = .white
                    completedBtn.setTitleColor(.blue, for: .normal)
                }else if (pagerVC.viewControllers?.first is AvailableJobsViewController){
                    availableBtn.backgroundColor = .blue
                    availableBtn.setTitleColor(.white, for: .normal)
                    
                    completedBtn.backgroundColor = .white
                    completedBtn.setTitleColor(.blue, for: .normal)
                }else{
                    print("WRONG")
                }
            }
        }
    }

}
