//
//  IntroAnimationViewController.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 3/2/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import Foundation
import UIKit

class IntroAnimationViewController: UIViewController {
    private typealias ConstraintSet = (top: NSLayoutConstraint, leading: NSLayoutConstraint)
    private typealias LabelSet = (label: UILabel, constraints: ConstraintSet)
    
    private let labelTexts: [String] = [.missing, .murdered, .indigenous, .women]
    
    private let initialAnimationDuration = 3.0
    private let animationFullWordsDelay = 1.5
    private let labelsLeadingMargin: CGFloat = 36
    private let labelsTopMargin: CGFloat = 47
    private let labelsVerticalDistance: CGFloat = 68
    
    private var animatedLabels: [LabelSet] = []
    private var backgroundHandView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundHandView = addBackground()
        setupLabels()
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
    
    private func setupLabels() {
        labelTexts.forEach {
            let animatedLabel = UILabel()
            animatedLabel.text = $0
            animatedLabel.font = .roboto48
            animatedLabel.textColor = .white
            animatedLabel.lineBreakMode = .byClipping
            
            view.addSubview(animatedLabel)
            animatedLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingConstraint = animatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: labelsLeadingMargin)
            leadingConstraint.isActive = true
            let topConstraint = animatedLabel.topAnchor.constraint(equalTo: view.bottomAnchor)
            topConstraint.isActive = true
            
            let labelSet = LabelSet(label: animatedLabel, constraints: ConstraintSet(top: topConstraint, leading: leadingConstraint))
            animatedLabels.append(labelSet)
        }
    }
    
    private func startAnimation() {
        for (i, labelSet) in animatedLabels.enumerated() {
            UIView.animate(withDuration: initialAnimationDuration, delay: TimeInterval(i) * 0.2, animations: { [weak self] in
                guard let self = self else { return }
                
                labelSet.constraints.top.isActive = false
                let newTopConstraint = labelSet.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.labelsTopMargin + CGFloat(i) * self.labelsVerticalDistance)
                newTopConstraint.isActive = true
                self.animatedLabels[i].constraints.top = newTopConstraint
                
                self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                if i == self.animatedLabels.count - 1 {
                    self.animateToAcronym()
                }
            })
        }
    }
    
    private func animateToAcronym() {
        let hashtagLabel = UILabel()
        hashtagLabel.text = "#"
        hashtagLabel.font = .roboto48
        hashtagLabel.textColor = .white
        hashtagLabel.alpha = 0
        
        let labelSummedWidth = labelTexts
            .flatMap { "\($0.first ?? Character(""))" }
            .reduce("#", {"\($0)\($1)"})
            .width(for: .roboto48)
        view.addSubview(hashtagLabel)
        hashtagLabel.translatesAutoresizingMaskIntoConstraints = false
        hashtagLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -labelSummedWidth / 2).isActive = true
        hashtagLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: labelsTopMargin).isActive = true
        
        let newBackground = addBackground(withTint: .offRed)
        newBackground.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: initialAnimationDuration, delay: animationFullWordsDelay, animations: { [weak self] in
            self?.backgroundHandView?.alpha = 0
            newBackground.alpha = 1
        })
        
        UIView.animate(withDuration: initialAnimationDuration / 2, delay: animationFullWordsDelay + initialAnimationDuration, animations: {
            hashtagLabel.alpha = 1
        })
        
        var previousTrailingAnchor = hashtagLabel.trailingAnchor
        
        for (i, labelSet) in animatedLabels.enumerated() {
            let widthConstraint = labelSet.label.widthAnchor.constraint(equalToConstant: labelSet.label.width)
            widthConstraint.isActive = true
            
            UIView.animate(withDuration: initialAnimationDuration, delay: animationFullWordsDelay + TimeInterval(i) * 0.1, animations: { [weak self] in
                guard let self = self, let firstLetter = labelSet.label.text?.first else { return }
                
                labelSet.constraints.top.constant = self.labelsTopMargin
                widthConstraint.constant = "\(firstLetter)".width(for: .roboto48)
                
                labelSet.constraints.leading.isActive = false
                let newLeadingConstraint = labelSet.label.leadingAnchor.constraint(equalTo: previousTrailingAnchor)
                newLeadingConstraint.isActive = true
                self.animatedLabels[i].constraints.leading = newLeadingConstraint
                previousTrailingAnchor = labelSet.label.trailingAnchor
                
                self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                if i == self.animatedLabels.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.initialAnimationDuration) { [weak self] in
                        self?.transitionToIntroSlides()
                    }
                }
            })
        }
    }
    
    private func transitionToIntroSlides() {
        navigationController?.pushViewController(PageViewController(), animated: true)
    }
}
