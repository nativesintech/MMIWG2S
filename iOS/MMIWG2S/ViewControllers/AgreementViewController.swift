//
//  AgreementViewController.swift
//  MMIWG2S
//
//  Created by Marvin Amaro on 3/26/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import Foundation
import UIKit

class AgreementViewController: UIViewController {
    private typealias ConstraintSet = (top: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint, height: NSLayoutConstraint, bottom: NSLayoutConstraint,  centerx: NSLayoutConstraint)
    private typealias LabelSet = (label: UILabel, constraints: ConstraintSet)
    
    private let labelTexts: [String] = [.acceptance]
    
    private let initialAnimationDuration = 6.0
    private let animationFullWordsDelay = 1.5
    private let labelsLeadingMargin: CGFloat = 36
    private let labelsTrailingMargin: CGFloat = -36
    private let labelsTopMargin: CGFloat = 47
    private let labelsVerticalDistance: CGFloat = 68
    private let animatedLabel = UILabel()

    private var animatedLabels: [LabelSet] = []
    private var backgroundHandView: UIImageView?
    private var scrollingView: UIView = UIView()
    private var confirmButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundHandView = addBackground()
        setupMMIWHashtag()
        setupView()
        //setupLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }

    
    private func addBackground(withTint tint: UIColor? = nil) -> UIImageView {
        let handImage: UIImage?
        if let tint = tint {
            handImage = UIImage(named: "face-background")?.tint(with: tint)
        } else {
            handImage = UIImage(named: "face-background")
        }
        let backgroundView = UIImageView(image: handImage)
        backgroundView.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return backgroundView
    }

    
    private func setupView()
    {
        
        animatedLabel.text = .acceptance
        animatedLabel.font = .roboto24
        animatedLabel.textColor = .white
        //animatedLabel.backgroundColor = .red
        animatedLabel.numberOfLines = 0
        //animatedLabel.lineBreakMode = .byClipping

        confirmButton.setTitle("I Agree", for: .normal)
        confirmButton.backgroundColor = .red
//        confirmButton.addTarget(self, action: #selector(self.transitionToFacesARView()), for: .touchUpInside)

        view.addSubview(scrollingView)
        scrollingView.addSubview(animatedLabel)
        scrollingView.addSubview(confirmButton)

        //let gesturerecognizer = UITapGestureRecognizer(target: self, action: #selector(self.transitionToFacesARVView()))

        animatedLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        scrollingView.translatesAutoresizingMaskIntoConstraints = false

        //scrollingView constraints
        let leadingScrollingConstraint = scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        leadingScrollingConstraint.isActive = true
        let trailingScrollingConstraint = scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        trailingScrollingConstraint.isActive = true
        let topScrollingConstraint = scrollingView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topScrollingConstraint.isActive = true
        let bottomScrollingConstraint = scrollingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height)
        bottomScrollingConstraint.isActive = false
        
 //     label constraints
        let leadingConstraint = animatedLabel.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: labelsLeadingMargin)
        leadingConstraint.isActive = true
        let trailingConstraint = animatedLabel.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: labelsTrailingMargin)
        trailingConstraint.isActive = true
        let topConstraint = animatedLabel.topAnchor.constraint(equalTo: scrollingView.topAnchor, constant: 255)
        topConstraint.isActive = true

        let bottomConstraint = animatedLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant:60)
        bottomConstraint.isActive = false
        let heightConstraint = animatedLabel.heightAnchor.constraint(equalToConstant:400)
        heightConstraint.isActive = true
        //let widthConstraint = animatedLabel.widthAnchor.constraint(equalToConstant: 70)
        //widthConstraint.isActive = true
        let centerxConstraint = animatedLabel.centerXAnchor.constraint(equalTo:scrollingView.centerXAnchor)
        centerxConstraint.isActive = true
        
        // button constraints
        let leadingButtonConstraint = confirmButton.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: labelsLeadingMargin)
        leadingButtonConstraint.isActive = true
        let trailingButtonConstraint = confirmButton.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: labelsTrailingMargin)
        trailingButtonConstraint.isActive = true
 
        let topButtonConstraint = confirmButton.topAnchor.constraint(equalTo: animatedLabel.bottomAnchor, constant:60)
        topButtonConstraint.isActive = true
        let bottomButtonConstraint = confirmButton.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor, constant: 100)
        bottomButtonConstraint.isActive = false
        let heightButtonConstraint = confirmButton.heightAnchor.constraint(equalToConstant: 50)
        heightButtonConstraint.isActive = true
        //let widthButtonConstraint = confirmButton.widthAnchor.constraint(equalToConstant: 100)
        //widthButtonConstraint.isActive = true
        let centerxButtonConstraint = confirmButton.centerXAnchor.constraint(equalTo:scrollingView.centerXAnchor)
        centerxButtonConstraint.isActive = true


    }
    
    private func startAnimation() {
            UIView.animate(withDuration: initialAnimationDuration, delay: TimeInterval(0) * 0.2, animations: { [weak self] in
                guard let self = self else { return }
                
           //     scrollingView.constraints.top.isActive = false
                let newTopConstraint = self.scrollingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
                newTopConstraint.isActive = true
             //   self.animatedLabels[i].constraints.top = newTopConstraint
 
                let newBottomConstraint = self.scrollingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                newBottomConstraint.isActive = true
                //self.animatedLabels[0].constraints.bottom = newBottomConstraint

                self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                /* if i == self.animatedLabels.count - 1 {
                    self.animateToAcronym()
                } */
            })

    }
    
    
    private func setupMMIWHashtag() {
        let hashtagLabel = UILabel()
        hashtagLabel.text = "#MMIW"
        hashtagLabel.font = .roboto48
        hashtagLabel.textColor = .white
        hashtagLabel.alpha = 1
        
        let hashtagString:String = "#MMIW"
        let labelSummedWidth = hashtagString.width(for:.roboto48)
        hashtagLabel.text = hashtagString
        view.addSubview(hashtagLabel)

        hashtagLabel.translatesAutoresizingMaskIntoConstraints = false
        hashtagLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -labelSummedWidth / 2).isActive = true
        hashtagLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: labelsTopMargin).isActive = true
        view.layoutIfNeeded()

    }
    
    @objc private func transitionToFacesARView() {
        navigationController?.pushViewController(FacesARViewController(), animated: true)
    }
}
