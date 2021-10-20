//
//  ShareSheetView.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 5/7/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

protocol ShareSheetViewDelegate {
    func shareInfo(name: String, email: String)
}

class ShareSheetView: UIStackView {
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 12
    private let animationViewBottomSpacing: CGFloat = 48

    private var imageView: UIImageView?
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let nameFieldLabel = UILabel()
    private let nameField = ShareSheetViewTextField()
    private let nameErrorLabel = UILabel()
    private let emailFieldLabel = UILabel()
    private let emailField = ShareSheetViewTextField()
    private let emailErrorLabel = UILabel()
    private let shareButton = UIButton()
    private let skipButton = UIButton()
    private var backButtonAction: (() -> Void)?
    private var shareButtonAction: ((_ name: String, _ email: String) -> Void)?
    private var skipButtonAction: (() -> Void)?

    public var delegate: ShareSheetViewDelegate?

    struct ShareSheetViewConfig {
        let image: UIImage
        let title: String
        let message: String
    }

    convenience init(viewConfig: ShareSheetViewConfig) {
        self.init()

        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        backgroundColor = .offBlack
        layer.cornerRadius = cornerRadius
        isLayoutMarginsRelativeArrangement = true

        setupBackButton()
        setupImageView(with: viewConfig.image)

        setupLabel(with: titleLabel, text: viewConfig.title, font: .roboto24, customSpacing: 12)
        setupLabel(with: messageLabel, text: viewConfig.message, font: .roboto16, customSpacing: 20)

        setupField(with: nameFieldLabel, field: nameField, text: .sharepagename, fieldCustomSpacing: 8, isEmail: false)
        setupErrorLabel(with: nameErrorLabel, customSpacing: 16)

        setupField(with: emailFieldLabel, field: emailField, text: .sharepageemail, fieldCustomSpacing: 16, isEmail: true)
        setupErrorLabel(with: emailErrorLabel, customSpacing: 16)

        setupButton(button: shareButton, backgroundColor: .offRed, buttonTitle: .sharepageshare, selector: #selector(shareButtonTapped))
        setupButton(button: skipButton, backgroundColor: .clear, buttonTitle: .sharepageskip, selector: #selector(skipButtonTapped))
    }

    private func setupErrorLabel(with label: UILabel, customSpacing: CGFloat) {
        label.text = .sharepageerrorlabel
        label.isHidden = true
        label.font = .roboto14
        label.textColor = .systemRed
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(label)
        setCustomSpacing(customSpacing, after: label)
    }

    private func setupBackButton() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        let backButton = UIButton()
        backButton.setBackgroundImage(UIImage(named: "back-icon"), for: .normal)
        backButton.contentMode = .scaleAspectFit

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        addArrangedSubview(stackView)
    }

    private func setupImageView(with image: UIImage) {
        imageView = UIImageView()
        if let imageView = imageView {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            addArrangedSubview(imageView)
            setCustomSpacing(22, after: imageView)
        }
    }

    private func setupLabel(with label: UILabel, text: String, font: UIFont, customSpacing: CGFloat) {
        label.text = text
        label.font = font
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(label)
        setCustomSpacing(customSpacing, after: label)
    }

    private func setupField(with label: UILabel, field: UITextField, text: String, fieldCustomSpacing: CGFloat, isEmail: Bool) {
        label.text = text
        label.textColor = .lightGray
        label.font = .roboto14
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(label)
        setCustomSpacing(8, after: label)

        field.textColor = .lightGray
        field.backgroundColor = .lightGrayThirdAlpha
        field.bounds.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        field.keyboardType = isEmail ? .emailAddress : .namePhonePad
        if isEmail {
            field.autocapitalizationType = .none
        }
        field.tintColor = .lightGray
        field.setContentHuggingPriority(.required, for: .vertical)
        field.setContentCompressionResistancePriority(.required, for: .vertical)
        addArrangedSubview(field)
        setCustomSpacing(fieldCustomSpacing, after: field)
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
        setCustomSpacing(16, after: button)
    }

    @objc private func skipButtonTapped() {
        skipButtonAction?()
    }

    @objc private func backButtonTapped() {
        backButtonAction?()
    }

    @objc private func shareButtonTapped() {
        guard let nameFieldText = nameField.text,
              let emailFieldText = emailField.text else {
                  print("Error sharing image: Name or Email field text was nil")
                  return
              }

        let nameFieldTextIsValid = !nameFieldText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let emailFieldTextIsValid = emailFieldText.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail()

        if nameFieldTextIsValid {
            setError(fieldLabel: nameFieldLabel, field: nameField, errorLabel: nameErrorLabel, show: false)
        } else {
            setError(fieldLabel: nameFieldLabel, field: nameField, errorLabel: nameErrorLabel, show: true)
        }

        if emailFieldTextIsValid {
            setError(fieldLabel: emailFieldLabel, field: emailField, errorLabel: emailErrorLabel, show: false)
        } else {
            setError(fieldLabel: emailFieldLabel, field: emailField, errorLabel: emailErrorLabel, show: true)
        }

        if nameFieldTextIsValid && emailFieldTextIsValid {
            shareButtonAction?(nameFieldText, emailFieldText)
        }
    }

    func setbuttonActions(backAction: @escaping (() -> Void), shareAction: @escaping ((_ name: String, _ email: String) -> Void), skipAction: @escaping (() -> Void)) {
        backButtonAction = backAction
        shareButtonAction = shareAction
        skipButtonAction = skipAction
    }

    func setTextFieldDelegates(delegate: UITextFieldDelegate) {
        nameField.delegate = delegate
        emailField.delegate = delegate
    }

    func setTextFieldFirstResponder() {
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if emailField.isFirstResponder {
            emailField.resignFirstResponder()
            nameField.becomeFirstResponder()
        }
    }

    func setError(fieldLabel: UILabel, field: UITextField, errorLabel: UILabel, show: Bool) {
        let color = show ? UIColor.systemRed : .white
        fieldLabel.textColor = color
        errorLabel.isHidden = !show
        layoutIfNeeded()
    }
}

class ShareSheetViewTextField: UITextField {
    let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
