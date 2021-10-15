//
//  ThankYouSheetView.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 10/14/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit
import WebKit

class ThankYouSheetView: UIStackView {
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 12
    private let animationViewBottomSpacing: CGFloat = 48

    private let headerLabel = UILabel()
    private let videoDescriptionLabel = UILabel()
    private let subheaderLabel = UILabel()
    private let thankYouBodyLabel = UILabel()
    private var backButtonAction: (() -> Void)?

    struct ThankYouSheetViewConfig {
        let showBackButton: Bool
        let header: String
        let videoDescription: String
        let videoUrl: String
        let subheader: String
        let thankYouBody: String
    }

    convenience init(viewConfig: ThankYouSheetViewConfig) {
        self.init()

        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        backgroundColor = .offBlack
        layer.cornerRadius = cornerRadius
        isLayoutMarginsRelativeArrangement = true
        translatesAutoresizingMaskIntoConstraints = false

        if viewConfig.showBackButton { setupBackButton() }

        setupLabel(with: headerLabel, text: viewConfig.header, font: .roboto48, customSpacing: 24, numberOfLines: 1)
        setupLabel(with: videoDescriptionLabel, text: viewConfig.videoDescription, font: .roboto16, customSpacing: 24)

        setupPlayerView(url: viewConfig.videoUrl)

        setupLabel(with: subheaderLabel,
                   text: viewConfig.subheader,
                   font: MmiwUtility.isPad ? .roboto36 : .roboto24,
                   customSpacing: 12,
                   numberOfLines: 1)
        setupLabel(with: thankYouBodyLabel,
                   text: viewConfig.thankYouBody,
                   font: MmiwUtility.isPad ? .roboto24 : .roboto16,
                   customSpacing: 20)
    }

    private func setupLabel(with label: UILabel, text: String, font: UIFont, customSpacing: CGFloat, numberOfLines: Int = 0) {
        label.text = text
        label.font = font
        label.textColor = .lightGray
        label.numberOfLines = numberOfLines
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(label)
        setCustomSpacing(customSpacing, after: label)
    }

    private func setupPlayerView(url: String) {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true

        let webPlayerView = WKWebView(frame: .zero, configuration: webConfiguration)
        webPlayerView.backgroundColor = .offRed
        webPlayerView.setContentCompressionResistancePriority(.required, for: .horizontal)
        webPlayerView.setContentHuggingPriority(.required, for: .horizontal)
        webPlayerView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(webPlayerView)
        setCustomSpacing(32, after: webPlayerView)
        NSLayoutConstraint.activate([
            webPlayerView.heightAnchor.constraint(equalToConstant: Int.toDeviceFormattedCGFloat(ipad: 350, iphone: 200)),
            webPlayerView.widthAnchor.constraint(equalToConstant: Int.toDeviceFormattedCGFloat(ipad: 350, iphone: 200)),
        ])

        DispatchQueue.main.async {
            guard let videoURL = URL(string: "\(url)?playsinline=1") else { return }
            let request = URLRequest(url: videoURL)
            webPlayerView.load(request)
        }
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

    @objc private func backButtonTapped() {
        backButtonAction?()
    }

    func setbuttonActions(backAction: @escaping (() -> Void)) {
        backButtonAction = backAction
    }
}
