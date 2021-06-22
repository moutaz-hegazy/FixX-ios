//
//  MyOrdersViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController,
                              UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var ongoingBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var pagerContainerView: UIView!
    
    
    private var controllers = [UIViewController]()
    private var ongoingVC : OngoingOrdersViewController?
    private var completedVC : CompletedOrdersViewController?
    
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
        
        controllers += [ongoingVC!,completedVC!]
        pagerVC.setViewControllers([ongoingVC!], direction: .forward, animated: true){ [weak self] (_) in
            self?.ongoingBtn.backgroundColor = .blue
            self?.ongoingBtn.setTitleColor(.white, for: .normal)
            
            self?.completedBtn.backgroundColor = .white
            self?.completedBtn.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func opnedOngoing(_ sender: UIButton) {
        pagerVC.setViewControllers([ongoingVC!], direction: .reverse, animated: true){ [weak self] (_) in
            self?.ongoingBtn.backgroundColor = .blue
            self?.ongoingBtn.setTitleColor(.white, for: .normal)
            
            self?.completedBtn.backgroundColor = .white
            self?.completedBtn.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func openCompleted(_ sender: UIButton) {
        pagerVC.setViewControllers([completedVC!], direction: .forward, animated: true){ [weak self] (_) in
            self?.ongoingBtn.backgroundColor = .white
            self?.ongoingBtn.setTitleColor(.blue, for: .normal)
            
            self?.completedBtn.backgroundColor = .blue
            self?.completedBtn.setTitleColor(.white, for: .normal)
        }
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
            if(previousViewControllers.first is OngoingOrdersViewController){
                ongoingBtn.backgroundColor = .white
                ongoingBtn.setTitleColor(.blue, for: .normal)
                
                completedBtn.backgroundColor = .blue
                completedBtn.setTitleColor(.white, for: .normal)
            }else{
                ongoingBtn.backgroundColor = .blue
                ongoingBtn.setTitleColor(.white, for: .normal)
                
                completedBtn.backgroundColor = .white
                completedBtn.setTitleColor(.blue, for: .normal)
            }
        }
    }
}
