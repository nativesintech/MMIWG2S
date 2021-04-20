//
//  HapticButton.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 4/17/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class IconButton: UIStackView {
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let imageHeight: CGFloat = 24
    private let imageWidth: CGFloat = 24
    private let viewWidth: CGFloat = 50
    private let imageAndLabelSpacing: CGFloat = 12

    init(image: UIImage, text: String) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: viewWidth).isActive = true

        axis = .vertical
        alignment = .center
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: imageWidth)
        ])
        addArrangedSubview(imageView)
        setCustomSpacing(imageAndLabelSpacing, after: imageView)

        textLabel.text = text
        textLabel.font = .roboto16
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        addArrangedSubview(textLabel)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
