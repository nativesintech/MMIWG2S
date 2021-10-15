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
    private let initialAnimationDuration = 2.0
    private let labelsVerticalDistance: CGFloat = 68
    private let trailingLeadingMargin: CGFloat = UIScreen.main.bounds.width > 360 ? 42 : 12
    private let confirmationButtonHeight: CGFloat = 50
    private var bottomMargin: CGFloat { return MmiwUtility.isPad ? -self.trailingLeadingMargin : -8 }
    private let topMargin: CGFloat = Int.toDeviceFormattedCGFloat(ipad: 120, iphone: 100)
    private let spacing: CGFloat = Int.toDeviceFormattedCGFloat(ipad: 60, iphone: 40)
    
    private let agreementParagraphCount = 4

    private let agreementView = UIView()
    private var agreementViewBottomConstraint: NSLayoutConstraint?

    private var agreementLabels = [(UILabel, NSLayoutConstraint)]()
    private var agreeButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    private func addBackground(withTint tint: UIColor? = nil) {
        let handImage: UIImage?
        if let tint = tint {
            handImage = UIImage(named: "face-background")?.tint(with: tint)
        } else {
            handImage = UIImage(named: "face-background")
        }
        let backgroundView = UIImageView(image: handImage)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupView() {

        view.addSubview(agreementView)
        agreementView.translatesAutoresizingMaskIntoConstraints = false
        
        let agreementViewBottomConstraint = agreementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: confirmationButtonHeight - bottomMargin + 40)
        self.agreementViewBottomConstraint = agreementViewBottomConstraint
        
        NSLayoutConstraint.activate([
            agreementView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: trailingLeadingMargin),
            agreementView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingLeadingMargin),
            agreementViewBottomConstraint,
            agreementView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        for i in 1...agreementParagraphCount {
            let agreementLabel = UILabel()
            agreementLabel.text = .acceptance(number: i)
            agreementLabel.font = UIScreen.main.bounds.width > 360 ? .roboto24 : .roboto17
            agreementLabel.textColor = .white
            agreementLabel.numberOfLines = 0
            agreementView.addSubview(agreementLabel)
            agreementLabel.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = agreementLabel.topAnchor.constraint(equalTo: agreementView.topAnchor, constant: view.frame.height)
            NSLayoutConstraint.activate([
                agreementLabel.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor),
                agreementLabel.trailingAnchor.constraint(lessThanOrEqualTo: agreementView.trailingAnchor),
                topConstraint
            ])
            agreementLabels.append((agreementLabel, topConstraint))
        }

        agreeButton.setTitle(.agree, for: .normal)
        agreeButton.backgroundColor = .offRed
        agreeButton.addTarget(self, action: #selector(transitionToFacesARView), for: .touchUpInside)
        agreementView.addSubview(agreeButton)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agreeButton.heightAnchor.constraint(equalToConstant: confirmationButtonHeight),
            agreeButton.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor),
            agreeButton.trailingAnchor.constraint(equalTo: agreementView.trailingAnchor),
            agreeButton.bottomAnchor.constraint(equalTo: agreementView.bottomAnchor)
        ])
    }

    private func startAnimation() {
        UIView.animate(withDuration: initialAnimationDuration, delay: 1.2 * Double(agreementParagraphCount), animations: { [weak self] in
            guard let self = self else { return }
            self.agreementViewBottomConstraint?.constant = self.bottomMargin

            self.view.layoutIfNeeded()
        })
        
        for (i, agreementLabel) in agreementLabels.enumerated() {
            UIView.animate(withDuration: initialAnimationDuration, delay: 1.2 * TimeInterval(i), animations: { [weak self] in
                guard let self = self else { return }
//                let paragraphCount = CGFloat(self.agreementParagraphCount)
//                let multiplier = min((self.view.frame.height - 250) / paragraphCount, self.view.frame.height / (paragraphCount + 3))
//                let topConstant = self.topMargin + CGFloat(i) * multiplier
//                agreementLabel.1.constant = topConstant
                agreementLabel.1.isActive = false
                let previousAnchor = i > 0 ? self.agreementLabels[i - 1].0.bottomAnchor : self.agreementView.topAnchor
                let constant = i > 0 ? self.spacing : self.topMargin
                agreementLabel.0.topAnchor.constraint(equalTo: previousAnchor, constant: constant).isActive = true
                
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func transitionToFacesARView() {
        var nextViewController: UIViewController {
            if let infoSheetViewController = MmiwUtility.faceViewController as? InfoSheetViewController {
                infoSheetViewController.setupButtonActions { [weak self] in
                    // TODO use Thank You view controller.
                    self?.navigationController?.pushViewController(InfoSheetViewController(image: UIImage.init(named: "ar-background"), title: "TESTING !@#", message: "aldskjfhlaksjdhfahsldf lkajsdlf alskdjhf lkajshdlf asldfhlaskjdhflas dhfla sdlfjh asdjhfhl akjdshf "), animated: true)
                }
                return infoSheetViewController
            } else {
                return MmiwUtility.faceViewController
            }
        }

        navigationController?.pushViewController(nextViewController, animated: true)

        MmiwUtility.saveUserDefaultBool(defaultType: MmiwUtility.UserDefaultKey.accepted, with: true)
    }
}
