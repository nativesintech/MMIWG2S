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
    private let initialAnimationDuration = 3.0
    private let labelsVerticalDistance: CGFloat = 68

    private let agreementView = UIView()
    private var agreementViewHeightConstraint: NSLayoutConstraint?

    private let agreementLabel = UILabel()
    private var agreeButton: UIButton = UIButton()
    let hashtagLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        setupMMIWHashtag()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        startAnimation()
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
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupMMIWHashtag() {
        let labelsTopMargin: CGFloat = 24

        hashtagLabel.font = .roboto36
        hashtagLabel.textColor = .white
        hashtagLabel.alpha = 1

        let hashtagString: String = .slideviewheader
        hashtagLabel.text = hashtagString
        view.addSubview(hashtagLabel)
        hashtagLabel.translatesAutoresizingMaskIntoConstraints = false

        hashtagLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        hashtagLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: labelsTopMargin).isActive = true
        view.layoutIfNeeded()
    }

    private func setupView() {
        let trailingLeadingMargin: CGFloat = 42
        let confirmationButtonHeight: CGFloat = 50
        let confirmationButtonTopMargin: CGFloat = 16

        view.addSubview(agreementView)
        agreementView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agreementView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: trailingLeadingMargin),
            agreementView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingLeadingMargin),
            agreementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            agreementView.topAnchor.constraint(equalTo: hashtagLabel.bottomAnchor, constant: 16)
        ])

        agreementLabel.text = .acceptance
        agreementLabel.font = .roboto24
        agreementLabel.textColor = .white
        agreementLabel.numberOfLines = 0
        agreementView.addSubview(agreementLabel)
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agreementLabel.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor),
            agreementLabel.trailingAnchor.constraint(equalTo: agreementView.trailingAnchor)
        ])

        agreeButton.setTitle(.agree, for: .normal)
        agreeButton.backgroundColor = .offRed
        agreeButton.addTarget(self, action: #selector(transitionToFacesARView), for: .touchUpInside)
        agreementView.addSubview(agreeButton)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agreeButton.heightAnchor.constraint(equalToConstant: confirmationButtonHeight),
            agreeButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: confirmationButtonTopMargin),
            agreeButton.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor),
            agreeButton.trailingAnchor.constraint(equalTo: agreementView.trailingAnchor),
            agreeButton.bottomAnchor.constraint(equalTo: agreementView.bottomAnchor)
        ])
    }

//    private func startAnimation() {
//        UIView.animate(withDuration: initialAnimationDuration, delay: TimeInterval(0) * 0.2, animations: { [weak self] in
//            guard let self = self else { return }
//            self.agreementViewHeightConstraint?.constant = (UIDevice.current.userInterfaceIdiom == .pad) ? 360 : 480
//
//            self.view.layoutIfNeeded()
//        })
//    }

    @objc private func transitionToFacesARView() {
        navigationController?.pushViewController(MmiwUtility.faceViewController, animated: true)
        MmiwUtility.saveUserDefaultBool(defaultType: MmiwUtility.UserDefaultKey.accepted, with: true)
    }
}
