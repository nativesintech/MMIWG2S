//
//  IntroInfoView.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 10/13/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class InfoSheetView: UIStackView {
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 12
    private let animationViewBottomSpacing: CGFloat = 48

    private var imageView: UIImageView?
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let nextButton = UIButton()
    private var nextButtonAction: (() -> Void)?

    struct InfoSheetViewConfig {
        let image: UIImage
        let title: String
        let message: String
        let buttonName: String
    }

    convenience init(viewConfig: InfoSheetViewConfig) {
        self.init()

        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        backgroundColor = .offBlack
        layer.cornerRadius = cornerRadius
        isLayoutMarginsRelativeArrangement = true

        setupImageView(with: viewConfig.image)

        setupLabel(with: titleLabel,
                   text: viewConfig.title,
                   font: MmiwUtility.isPad ? .roboto36 : .roboto24,
                   customSpacing: 12,
                   numberOfLines: 1)
        setupLabel(with: messageLabel,
                   text: viewConfig.message,
                   font: MmiwUtility.isPad ? .roboto24 : .roboto16,
                   customSpacing: 20)

        setupButton(button: nextButton, backgroundColor: .offRed, buttonTitle: viewConfig.buttonName, selector: #selector(nextButtonTapped))
    }

    private func setupImageView(with image: UIImage) {
        imageView = UIImageView()
        if let imageView = imageView {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            addArrangedSubview(imageView)
            setCustomSpacing(32, after: imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: Int.toDeviceFormattedCGFloat(ipad: 350, iphone: 175)),
                imageView.heightAnchor.constraint(equalToConstant: Int.toDeviceFormattedCGFloat(ipad: 400, iphone: 200)),
                ])
        }
    }

    private func setupLabel(with label: UILabel, text: String, font: UIFont, customSpacing: CGFloat, numberOfLines: Int = 0) {
        label.text = text
        label.font = font
        label.textColor = .lightGray
        label.numberOfLines = numberOfLines
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(label)
        setCustomSpacing(customSpacing, after: label)
    }

    private func setupButton(button: UIButton, backgroundColor: UIColor, buttonTitle: String, selector: Selector) {
        button.backgroundColor = backgroundColor
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50)
            ])
    }

    @objc private func nextButtonTapped() {
        nextButtonAction?()
    }

    func setbuttonActions(nextAction: @escaping (() -> Void)) {
        nextButtonAction = nextAction
    }
}
