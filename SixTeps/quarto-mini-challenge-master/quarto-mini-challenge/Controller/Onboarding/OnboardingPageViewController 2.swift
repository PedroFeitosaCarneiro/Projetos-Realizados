//
//  OnboardingPageViewController.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 07/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    //Attributes
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newOnboardingViewController(page: .One),
                self.newOnboardingViewController(page: .Two),
                self.newOnboardingViewController(page: .Three)]
    }()
    
    private var pageControl: UIPageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.configurePageControl()

        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func newOnboardingViewController(page: Pages) -> UIViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: page.rawValue)
    }
    
    private func contentViewController(at index: Int) -> UIViewController?{
        if index < 0 || index >= orderedViewControllers.count{
            return nil
        }
        
        switch index {
        case 0:
            return orderedViewControllers[index] as? PageOneOnboardingViewController
        case 1:
            return orderedViewControllers[index] as? PageTwoOnboardingViewController
        case 2:
            return orderedViewControllers[index] as? PageThreeOnboardingViewController
        default:
            return nil
        }
    }
    
    private func configurePageControl() {
        pageControl.frame = CGRect(x: 0, y: view.frame.height-view.frame.size.height*0.1, width: view.frame.size.width, height: view.frame.size.height*0.1)
        pageControl.currentPage = 0
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = .lightGray
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .lightGray
        self.view.addSubview(pageControl)
    }

}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        self.pageControl.currentPage = viewControllerIndex
        
        return contentViewController(at: previousIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        self.pageControl.currentPage = viewControllerIndex
        
        return contentViewController(at: nextIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: pageViewController.viewControllers![0]) else {
            return
        }
        
        self.pageControl.currentPage = viewControllerIndex
    }
    
    
    
}

enum Pages: String, CaseIterable {
    case One = "PageOneOnboardingViewController";
    case Two = "PageTwoOnboardingViewController";
    case Three = "PageThreeOnboardingViewController";
}
