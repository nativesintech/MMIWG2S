//
//  PageViewController.swift
//  MMIWG2S
//
//  Created by Mark Amaro on 8/21/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit
import ARKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    let labelMMIW = UILabel()
    let nextButtonStackView = UIStackView()
    let pageControlViews: [UIView] = [UIView(), UIView(), UIView(), UIView()]
    
    private var array: [IntroViewController] = [
        IntroViewController(background: UIImage(named: "slide1") ?? UIImage(), gradient: UIImage(named: "gradient1") ?? UIImage(), mmiwtext: .statistic(number: 1), page: 0),
        IntroViewController(background: UIImage(named: "slide2") ?? UIImage(), gradient: UIImage(named: "gradient2") ?? UIImage(), mmiwtext: .statistic(number: 2), page: 1),
        IntroViewController(background: UIImage(named: "slide3") ?? UIImage(), gradient: UIImage(named: "gradient3") ?? UIImage(), mmiwtext: .statistic(number: 3), page: 2) ,
        IntroViewController(background: UIImage(named: "slide4") ?? UIImage(), gradient: UIImage(named: "gradient4") ?? UIImage(), mmiwtext: .statistic(number: 4), page: 3)
    ]

    private var currentViewIndex: Int {
        get {
            if let currentViewController = self.viewControllers?.first,
               let currentViewControllerIndex = orderedViewControllers.firstIndex(of: currentViewController) {
                return currentViewControllerIndex
            } else {
                return -1
            }
        }
    }
    
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
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction:.forward,
                               animated:true,
                               completion:nil)
        }

        setupHeader()
        setupNextButton()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
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
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
}

// MARK: Views

extension PageViewController {
    private func setupHeader() {
        labelMMIW.textAlignment = .center
        labelMMIW.text = .slideviewheader
        labelMMIW.textColor = .white
        labelMMIW.font = .roboto36

        view.addSubview(labelMMIW)
        labelMMIW.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelMMIW.heightAnchor.constraint(equalToConstant: 50),
            labelMMIW.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            labelMMIW.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func setupNextButton() {
        nextButtonStackView.alignment = .center
        nextButtonStackView.axis = .horizontal
        nextButtonStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        nextButtonStackView.isLayoutMarginsRelativeArrangement = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.nextSlide))
        nextButtonStackView.addGestureRecognizer(tap)

        view.addSubview(nextButtonStackView)
        nextButtonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nextButtonStackView.heightAnchor.constraint(equalToConstant: 48),
            nextButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nextButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        nextButtonStackView.setCustomSpacing(12, after: nextButtonStackView)

        let labelFont: UIFont = .roboto17
        for (index,item) in pageControlViews.enumerated() {
            if index == 0 {
                item.backgroundColor = .red
            } else {
                item.backgroundColor = .white
            }

            item.widthAnchor.constraint(equalToConstant: 2).isActive = true
            item.heightAnchor.constraint(equalToConstant: labelFont.xHeight + 6).isActive = true
            item.setContentHuggingPriority(.required, for: .horizontal)
            item.setContentCompressionResistancePriority(.required, for: .horizontal)
            nextButtonStackView.addArrangedSubview(item)
            nextButtonStackView.setCustomSpacing(3, after: item)
        }

        let nextLabel = UILabel()
        nextLabel.font = labelFont
        nextLabel.textColor = .white
        nextLabel.text = .next

        nextButtonStackView.addArrangedSubview(nextLabel)
        nextButtonStackView.setCustomSpacing(80, after: nextLabel)
    }

    @objc func nextSlide() {
        let nextViewControllerIndex = currentViewIndex + 1
        if nextViewControllerIndex < orderedViewControllers.count - 1 {
            setNextButtonIndicatorColors(with: nextViewControllerIndex)
            setViewControllers([array[nextViewControllerIndex]],
                               direction:.forward,
                               animated:true,
                               completion:nil)
        } else {
            let termsAccepted = MmiwUtility.getUserDefaultBool(defaultType: MmiwUtility.UserDefaultKey.accepted)

            labelMMIW.isHidden = termsAccepted
            nextButtonStackView.isHidden = true
            setViewControllers(termsAccepted ? [MmiwUtility.faceViewController] : [AgreementViewController()],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    // MARK: View Update Methods

    private func setNextButtonIndicatorColors(with currentViewControllerIndex: Int) {
        for (index,item) in pageControlViews.enumerated() {
            if index == currentViewControllerIndex {
                item.backgroundColor = .red
            } else {
                item.backgroundColor = .white
            }
        }
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard currentViewIndex >= 0 else {
            print("Warning: PageViewController: currentViewIndex was not set.")
            return
        }

        if completed {
            setNextButtonIndicatorColors(with: currentViewIndex)
            nextButtonStackView.isHidden = currentViewIndex >= 4
        }
    }
}
