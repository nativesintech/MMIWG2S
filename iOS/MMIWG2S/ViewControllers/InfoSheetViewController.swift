//
//  InfoSheetViewController.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 10/13/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class InfoSheetViewController: UIViewController {
    private let sheetViewWidth: CGFloat = Int.toDeviceFormattedCGFloat(ipad: 440, iphone: 350)

    private var infoSheetView = InfoSheetView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    convenience init(image: UIImage?, title: String, message: String, buttonName: String) {
        self.init()

        view.backgroundColor = .offBlack
        modalPresentationStyle = .pageSheet
        modalTransitionStyle = .coverVertical

        if let image = image {
            infoSheetView = InfoSheetView(
                viewConfig: InfoSheetView.InfoSheetViewConfig(
                    image: image,
                    title: title,
                    message: message,
                    buttonName: buttonName
                )
            )
        }

        view.addSubview(infoSheetView)
        infoSheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoSheetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoSheetView.widthAnchor.constraint(equalToConstant: sheetViewWidth),
            infoSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: Int.toDeviceFormattedCGFloat(ipad: 86, iphone: 64)),
            infoSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    func setupButtonActions(next: @escaping (() -> Void)) {
        infoSheetView.setbuttonActions(
            nextAction: {
                self.dismiss(animated: true, completion: { next() })
            }
        )
    }
}
