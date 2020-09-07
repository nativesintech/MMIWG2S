//
//  PageViewController.swift
//  MMIWG2S
//
//  Created by Marvin Amaro on 8/21/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDataSource, NextPageDelegate {
    
    var vController1 = ViewController1()
    let vController2 = ViewController2()
    let vController3 = ViewController3()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //vControllerGreen.view.backgroundColor = .blue
    /* vControllerBlue.view.backgroundColor = UIColor.blueColor()
    vControllerRed.view.backgroundColor = UIColor.redColor()
 */
//    vControllerGreen.view.backgroundColor = UIColor.greenn

//    private(set) lazy var orderedViewControllers:[UIViewController] = { return [ self.vControllerGreen, self.vControllerBlue, self.vControllerRed]}()
    private(set) lazy var orderedViewControllers:[UIViewController] = { return [ self.vController1, self.vController2, self.vController3]}()
 //   super.viewDidLoad()
/*    private(set) lazy var orderedViewControllers:[UIViewController] = {return [self.newColoredViewController(color: "Green"), self.newColoredViewController(color:"Red"), self.newColoredViewController(color:"Blue")]}()
*/
    //private func newColoredViewController(color:String) -> //UIViewController{ return UIStoryboard(name:"Main", bundle:nil) .  instantiateViewController(withIdentifier: "\(color)ViewController")
//}


    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction:.forward,
                              animated:true,
                              completion:nil)
        }
        vController1.delegate = self
        vController2.delegate = self
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
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

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

    

/*
extension TutorialPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?{}
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?{}

*/
/*
 func pageViewController(pageViewController: UIPageViewController,
     viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    return nil}
 
 func pageViewController(pageViewController: UIPageViewController,
     viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
         return nil}
*/
    func vc1tovc2() {
        setViewControllers([vController2],
         direction:.forward,
        animated:true,
        completion:nil)
    }
    
    func vc2tovc3() {
        setViewControllers([vController3],
         direction:.forward,
        animated:true,
        completion:nil)

    }


}
 
protocol NextPageDelegate {
    func vc1tovc2()
    func vc2tovc3()
}
