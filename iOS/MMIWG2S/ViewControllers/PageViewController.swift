//
//  PageViewController.swift
//  MMIWG2S
//
//  Created by Mark Amaro on 8/21/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit
import ARKit

protocol NextPageDelegate {
    func nextSlide(_ vcFrom: Int)
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, NextPageDelegate {
    
    private var array: [IntroViewController] = [
        IntroViewController(background: UIImage(named: "slide1") ?? UIImage(), gradient: UIImage(named: "gradient1") ?? UIImage(), mmiwtext: .statistic(number: 1), page: 0),
        IntroViewController(background: UIImage(named: "slide2") ?? UIImage(), gradient: UIImage(named: "gradient2") ?? UIImage(), mmiwtext: .statistic(number: 2), page: 1),
        IntroViewController(background: UIImage(named: "slide3") ?? UIImage(), gradient: UIImage(named: "gradient3") ?? UIImage(), mmiwtext: .statistic(number: 3), page: 2) ,
        IntroViewController(background: UIImage(named: "slide4") ?? UIImage(), gradient: UIImage(named: "gradient4") ?? UIImage(), mmiwtext: .statistic(number: 4), page: 3)
    ]
    
    override init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = { array + [AgreementViewController()] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction:.forward,
                               animated:true,
                               completion:nil)
        }
        array.forEach { $0.delegate = self }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func nextSlide(_ viewControllerFrom: Int) {
        if viewControllerFrom < orderedViewControllers.count - 2 {
            setViewControllers([array[viewControllerFrom + 1]],
                               direction:.forward,
                               animated:true,
                               completion:nil)
        } else {
            let termsAccepted = MmiwUtility.getUserDefaultBool(defaultType: MmiwUtility.UserDefaultKey.accepted)

            setViewControllers(termsAccepted ? [MmiwUtility.faceViewController] : [AgreementViewController()],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}
